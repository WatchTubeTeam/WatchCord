//
//  Gateway.swift
//  Accord
//
//  Created by evelyn on 2022-01-01.
//

import Combine
import Foundation

// The second version of Accord's gateway.
// This uses Network.framework instead of URLSessionWebSocketTask
final class Gateway {
    private(set) var connection: URLSessionWebSocketTask?
    private(set) var sessionID: String?

    internal var pendingHeartbeat: Bool = false
    internal var seq: Int = 0
    internal var bag = Set<AnyCancellable>()

    // To communicate with the view
    private (set) var messageSubject = PassthroughSubject<(Data, String, Bool), Never>()
    private (set) var editSubject = PassthroughSubject<(Data, String), Never>()
    private (set) var deleteSubject = PassthroughSubject<(Data, String), Never>()
    private (set) var typingSubject = PassthroughSubject<(Data, String), Never>()
    private (set) var memberChunkSubject = PassthroughSubject<Data, Never>()
    private (set) var memberListSubject = PassthroughSubject<MemberListUpdate, Never>()
    
    var presencePipeline = [String:PassthroughSubject<PresenceUpdate, Never>]()

//    private(set) var stateUpdateHandler: (NWConnection.State) -> Void = { state in
//        switch state {
//        case .ready:
//            print("Ready up")
//        case .cancelled:
//            print("Connection cancelled, what happened?")
//            wss.hardReset()
//        case let .failed(error):
//            print("Connection failed \(error.debugDescription)")
//        case .preparing:
//            print("Preparing")
//        case let .waiting(error):
//            print("Spinning infinitely \(error.debugDescription)")
//        case .setup:
//            print("Setting up")
//        @unknown default:
//            fatalError()
//        }
//    }
    
    func closeMessageHandler(_ message: String?) {
        guard let message = message?.lowercased() else {
            return
        }
        
        if message.contains("Not authenticated") || message.contains("Authentication failed") {
            logOut()
        }
    }

    internal let compress: Bool

    var cachedMemberRequest: [String: GuildMember] = [:]

    enum GatewayErrors: Error {
        case noStringData(String)
        case essentialEventFailed(String)
        case eventCorrupted
        case unknownEvent(String)
        case heartbeatMissed

        var localizedDescription: String {
            switch self {
            case let .essentialEventFailed(event):
                return "Essential Gateway Event failed: \(event)"
            case let .noStringData(string):
                return "Invalid data \(string)"
            case .eventCorrupted:
                return "Bad event sent"
            case let .unknownEvent(event):
                return "Unknown event: \(event)"
            case .heartbeatMissed:
                return "Heartbeat ACK missed"
            }
        }
    }

    private let additionalHeaders: [String:String] = [
        "User-Agent": discordUserAgent,
        "Pragma": "no-cache",
        "Origin": "https://discord.com",
        "Host": Gateway.gatewayURL.host ?? "gateway.discord.gg",
        "Accept-Language": "en-CA,en-US;q=0.9,en;q=0.8",
        "Accept-Encoding": "gzip, deflate, br",
    ]

    static var gatewayURL: URL = .init(string: "wss://gateway.discord.gg?v=9&encoding=json")!
    
    internal var decompressor = ZStream()
    
    public var presences: [Activity] = []
    
    init (
        url: URL = Gateway.gatewayURL,
        session_id: String? = nil,
        seq: Int? = nil,
        compress: Bool = true
    ) throws {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = self.additionalHeaders
        let session = URLSession(configuration: config)
        if compress {
            self.connection = session.webSocketTask(with: URL(string: "wss://gateway.discord.gg?v=9&encoding=json&compress=zlib-stream")!)
        } else {
            self.connection = session.webSocketTask(with: url)
        }
        self.connection?.maximumMessageSize = 1024 * 1024 * 1024
        self.compress = compress
        try connect(session_id, seq)
    }

    private func connect(_ session_id: String? = nil, _ seq: Int? = nil) throws {
        self.connection?.resume()
        Task {
            try await self.hello(session_id, seq)
        }
        do {
            if let session_id = session_id, let seq = seq {
                try self.reconnect(session_id: session_id, seq: seq)
            } else {
                print("identifying")
                try self.identify()
            }
        } catch {
            print(error)
        }
    }

    private func hello(_ session_id: String? = nil, _ seq: Int? = nil) async throws {
        guard connection?.state != .suspended else { return } // Don't listen for hello if there is no connection
        let message = try await self.connection?.receive()
        switch message {
        case .string(let text):
            print(text)
            guard let data = text.data(using: .utf8) else { return }
            guard let hello = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                  let helloD = hello["d"] as? [String:Any],
                  let interval = helloD["heartbeat_interval"] as? Int  else {
                    print("Failed to get a heartbeat interval")
                    return wss.hardReset()
            }
            DispatchQueue.main.async {
                Timer.publish(
                    every: Double(interval / 1000),
                    tolerance: nil,
                    on: .main,
                    in: .default
                )
                .autoconnect()
                .sink { _ in
                    wssThread.async {
                        do {
                            print("Heartbeating")
                            try self.heartbeat()
                        } catch {
                            print("Error sending heartbeat", error)
                        }
                    }
                }
                .store(in: &self.bag)
            }
        case .data(let data):
            let decompressed = try self.decompressor.decompress(data: data)
            print(String(data: decompressed, encoding: .utf8))
            guard let hello = try JSONSerialization.jsonObject(with: decompressed, options: []) as? [String:Any],
                  let helloD = hello["d"] as? [String:Any],
                  let interval = helloD["heartbeat_interval"] as? Int  else {
                    print("Failed to get a heartbeat interval")
                    return wss.hardReset()
            }
            DispatchQueue.main.async {
                Timer.publish(
                    every: Double(interval / 1000),
                    tolerance: nil,
                    on: .main,
                    in: .default
                )
                .autoconnect()
                .sink { _ in
                    wssThread.async {
                        do {
                            print("Heartbeating")
                            try self.heartbeat()
                        } catch {
                            print("Error sending heartbeat", error)
                        }
                    }
                }
                .store(in: &self.bag)
            }
        case .none: break
        case .some(_): break
        }
    }

    private func listen() async throws {
        guard connection?.state != .suspended else { return }
        let message = try await connection?.receive()
        switch message {
        case .data(let data):
            self.decompressor.decompressionQueue.async {
                guard let data = try? self.decompressor.decompress(data: data) else { return }
                wssThread.async {
                    do {
                        let event = try GatewayEvent(data: data)
                        try self.handleMessage(event: event)
                    } catch {
                        print(error)
                    }
                }
            }
        case .string(let text):
            guard let data = text.data(using: .utf8) else { return }
            wssThread.async {
                do {
                    let event = try GatewayEvent(data: data)
                    try self.handleMessage(event: event)
                } catch {
                    print(error)
                }
            }
        case .none:
            break
        @unknown default:
            break
        }
    }

    func identify() throws {
        let packet: [String: Any] = [
            "op": 2,
            "d": [
                "token": AccordCoreVars.token,
                "capabilities": 253,
                "compress": false,
                "client_state": [
                    "guild_hashes": [:],
                    "highest_last_message_id": "0",
                    "read_state_version": 0,
                    "user_guild_settings_version": -1,
                    "user_settings_version": -1,
                ],
                "presence": [
                    "activities": [],
                    "afk": false,
                    "since": 0,
                    "status": "online",
                ],
                "properties": [
                    "os": "Mac OS X",
                    "browser": "Discord Client",
                    "release_channel": "stable",
                    "client_build_number": dscVersion,
                    "client_version": "0.0.266",
                    "os_version": "21.2.0",
                    "os_arch": "x64",
                    "system-locale": "\(NSLocale.current.languageCode ?? "en")-\(NSLocale.current.regionCode ?? "US")",
                ],
            ],
        ]
        try send(json: packet)
    }

    func heartbeat() throws {
        guard !pendingHeartbeat else {
            return WatchCordApp.error(GatewayErrors.heartbeatMissed, additionalDescription: "Check your network connection")
        }
        let packet: [String: Any] = [
            "op": 1,
            "d": seq,
        ]
        try send(json: packet)
        pendingHeartbeat = true
    }

    func ready() -> Future<GatewayD, Error> {
        Future { [weak self] promise in
            self?.connection?.receive {
                switch $0 {
                case .success(let message):
                    switch message {
                    case .string(let text):
                        print(text)
                        guard let data = text.data(using: .utf8) else { return promise(.failure(GatewayErrors.noStringData(text))) }
                        wssThread.async {
                            do {
                                try wss.updateVoiceState(guildID: nil, channelID: nil)
                                let path = FileManager.default.urls(for: .cachesDirectory,
                                                                    in: .userDomainMask)[0]
                                    .appendingPathComponent("socketOut.json")
                                try data.write(to: path)
                                let structure = try JSONDecoder().decode(GatewayStructure.self, from: data)
                                Task.detached {
                                    try await wss.listen()
                                }
                                print("Hello, \(structure.d.user.username)#\(structure.d.user.discriminator) !!")
                                self?.sessionID = structure.d.session_id
                                print("Connected with session ID", structure.d.session_id)
                                promise(.success(structure.d))
                                return
                            } catch {
                                promise(.failure(error))
                                WatchCordApp.error(error)
                                return
                            }
                        }
                    case .data(let data):
                        self?.decompressor.decompressionQueue.async {
                            guard let data = try? self?.decompressor.decompress(data: data, large: true) else { return }
                            wssThread.async {
                                do {
                                    try wss.updateVoiceState(guildID: nil, channelID: nil)
                                    let path = FileManager.default.urls(for: .cachesDirectory,
                                                                        in: .userDomainMask)[0]
                                        .appendingPathComponent("socketOut.json")
                                    try data.write(to: path)
                                    let structure = try JSONDecoder().decode(GatewayStructure.self, from: data)
                                    Task.detached {
                                        try await wss.listen()
                                    }
                                    print("Hello, \(structure.d.user.username)#\(structure.d.user.discriminator) !!")
                                    self?.sessionID = structure.d.session_id
                                    print("Connected with session ID", structure.d.session_id)
                                    promise(.success(structure.d))
                                    return
                                } catch {
                                    promise(.failure(error))
                                    WatchCordApp.error(error)
                                    return
                                }
                            }
                        }
                    @unknown default: break
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func updatePresence(status: String, since: Int, @ActivityBuilder _ activities: () -> [Activity]) throws {
        try self.updatePresence(status: status, since: since, activities: activities())
    }
    
    func updatePresence(status: String, since: Int, activities: [Activity]) throws {
        self.presences = activities
        print(activities.map(\.dictValue))
        let packet: [String: Any] = [
            "op": 3,
            "d": [
                "status": status,
                "since": since,
                "activities": activities.map(\.dictValue),
                "afk": false,
            ],
        ]
        try send(json: packet)
    }

    func reconnect(session_id: String? = nil, seq: Int? = nil) throws {
        let packet: [String: Any] = [
            "op": 6,
            "d": [
                "seq": seq ?? self.seq,
                "session_id": session_id ?? sessionID ?? "",
                "token": AccordCoreVars.token,
            ],
        ]
        try send(json: packet)
        Task.detached {
            try await self.listen()
        }
    }

    func subscribe(to guild: String) throws {
        let packet: [String: Any] = [
            "op": 14,
            "d": [
                "guild_id": guild,
                "typing": true,
                "activities": true,
                "threads": true,
            ],
        ]
        try send(json: packet)
    }

    func memberList(for guild: String, in channel: String) throws {
        let packet: [String: Any] = [
            "op": 14,
            "d": [
                "channels": [
                    channel: [[
                        0, 99,
                    ]],
                ],
                "guild_id": guild,
            ],
        ]
        try send(json: packet)
    }

    func subscribeToDM(_ channel: String) throws {
        let packet: [String: Any] = [
            "op": 13,
            "d": [
                "channel_id": channel,
            ],
        ]
        try send(json: packet)
    }

    func getMembers(ids: [String], guild: String) throws {
        let packet: [String: Any] = [
            "op": 8,
            "d": [
                "limit": 0,
                "user_ids": ids,
                "guild_id": guild,
            ],
        ]
        try send(json: packet)
    }

    func getCommands(guildID: String, commandIDs: [String] = [], limit: Int = 10) throws {
        let packet: [String: Any] = [
            "op": 24,
            "d": [
                "applications": true,
                "command_ids": commandIDs,
                "guild_id": guildID,
                "limit": limit,
                "locale": NSNull(),
                "nonce": generateFakeNonce(),
                "offset": 0,
                "type": 1,
            ],
        ]
        try send(json: packet)
    }

    func getCommands(guildID: String, query: String, limit: Int = 10) throws {
        let packet: [String: Any] = [
            "op": 24,
            "d": [
                "locale": NSNull(),
                "query": query,
                "guild_id": guildID,
                "limit": limit,
                "nonce": generateFakeNonce(),
                "type": 1,
            ],
        ]
        try send(json: packet)
    }

    func listenForPresence(userID: String, action: @escaping ((PresenceUpdate) -> Void)) {
        self.presencePipeline[userID] = .init()
        self.presencePipeline[userID]?.sink(receiveValue: action).store(in: &self.bag)
    }
    
    func unregisterPresence(userID: String) {
        self.presencePipeline.removeValue(forKey: userID)
    }
    
    // cleanup
    deinit {
        self.bag.invalidateAll()
    }
}

@resultBuilder
enum ActivityBuilder {
    static func buildBlock() -> [Activity] { [] }
}

extension ActivityBuilder {
    static func buildBlock(_ activities: Activity...) -> [Activity] {
        activities
    }
}

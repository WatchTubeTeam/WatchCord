//
//  Constants.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 18/05/2022.
//

// By evelyn i just manually copypasted this and edited it

import Combine
import Foundation
import os
import SwiftUI

// Discord WebSocket
var wss: Gateway!

let rootURL: String = "https://discord.com/api/v9"
let cdnURL: String = "https://cdn.discordapp.com"
var user_id: String = .init()
var avatar: Data = .init()
public var pastelColors: Bool = UserDefaults.standard.bool(forKey: "pastelColors")
var sortByMostRecent: Bool = UserDefaults.standard.bool(forKey: "sortByMostRecent")
var pfpShown: Bool = UserDefaults.standard.bool(forKey: "pfpShown")
let discordUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) discord/0.0.266 Chrome/91.0.4472.164 Electron/13.6.6 Safari/537.36"
var dscVersion = 126_462

#if DEBUG
    let keychainItemName = "com.llsc12.watchcord.token.debug"
#else
    let keychainItemName = "com.llsc12.watchcord.token"
#endif

enum Storage {
    static var usernames: [String: String] = [:]
}

final class AccordCoreVars {
    // static var cancellable: Cancellable?

    // static var suffixes: Bool = UserDefaults.standard.bool(forKey: "enableSuffixRemover")
    static var token: String = .init(decoding: KeychainManager.load(key: keychainItemName) ?? Data(), as: UTF8.self)
    static var user: User?

//    func loadPlugins() {
//        let path = FileManager.default.urls(for: .documentDirectory,
//                                            in: .userDomainMask)[0]
//        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
//        for item in directoryContents {
//            if item.isFileURL {
//                let plugin = Plugins().loadView(url: String(item.absoluteString.dropFirst(7)))
//                Self.plugins.append(plugin!)
//            }
//        }
//    }
//
//    class func loadVersion() {
//        concurrentQueue.async {
//            Self.cancellable = RequestPublisher.fetch(Res.self, url: URL(string: "https://api.discord.sale"))
//                .sink(receiveCompletion: { _ in
//                }) { res in
//                    print(dscVersion)
//                    dscVersion = res.statistics.newest_build.number
//                    UserDefaults.standard.set(dscVersion, forKey: "clientVersion")
//                    print(dscVersion)
//                }
//        }
//    }
}

//class Res: Decodable {
//    var statistics: Response
//    class Response: Decodable {
//        class Build: Decodable {
//            var number: Int
//        }
//
//        var newest_build: Build
//    }
//}

#if DEBUG
    let rw = (
        dso: { () -> UnsafeMutableRawPointer in
            var info = Dl_info()
            dladdr(dlsym(dlopen(nil, RTLD_LAZY), "LocalizedString"), &info)
            return info.dli_fbase
        }(),
        log: OSLog(subsystem: "com.apple.runtime-issues", category: "WatchCord")
    )
#endif

#warning("TO DO")
func generateFakeNonce() -> String {
    let date: Double = Date().timeIntervalSince1970
    let nonceNumber = (Int64(date)*1000 - 1420070400000) * 4194304
    return String(nonceNumber)
}

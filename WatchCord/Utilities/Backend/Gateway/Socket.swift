//
//  Gateway.swift
//  Accord
//
//  Created by evelyn on 2021-06-05.
//

import Combine
import Foundation

final class Notifications {
    static var privateChannels: [String] = []
}

extension Gateway {
    func close(_ closeCode: URLSessionWebSocketTask.CloseCode) {
        connection?.cancel(with: closeCode, reason: nil)
    }

    func send<S>(text: S) throws where S: Collection, S.Element == Character {
        let text = String(text)
        let message = URLSessionWebSocketTask.Message.string(text)
        connection?.send(message, completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }

    func send<C: Collection>(json: C) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        let message = URLSessionWebSocketTask.Message.string(try String(jsonData))
        connection?.send(message, completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }

    func send(data: Data) throws {
        let message = URLSessionWebSocketTask.Message.string(try String(data))
        connection?.send(message, completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }

    func reset(function: String = #function) {
        print("resetting from function", function, wss.connection?.state as Any)

        if let state = wss.connection?.state, case URLSessionWebSocketTask.State.suspended = state {
            close(.protocolError)
        }
        concurrentQueue.async {
            guard let new = try? Gateway(url: Gateway.gatewayURL, session_id: wss.sessionID, seq: wss.seq) else { return }
            wss = new
        }
    }

    func hardReset(function: String = #function) {
        print("hard resetting from function", function)
        close(.normalClosure)
        concurrentQueue.async {
            guard let new = try? Gateway(url: Gateway.gatewayURL) else { return }
            new.ready().sink(receiveCompletion: doNothing, receiveValue: doNothing).store(in: &new.bag)
            wss = new
        }
    }
}

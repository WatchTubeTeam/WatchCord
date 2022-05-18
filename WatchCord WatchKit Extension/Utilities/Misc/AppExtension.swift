//
//  AppExtension.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 18/05/2022.
//

import Foundation
import WatchKit
extension WatchCordApp {
    #warning("This needs rewriting")
    static func error(_ error: Error? = nil, text: String? = nil, additionalDescription: String? = nil, reconnectOption _: Bool = true) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = error?.localizedDescription ?? text ?? "Unknown error occured"
            if let additionalDescription = additionalDescription {
                alert.informativeText = additionalDescription
            }
            alert.addButton(withTitle: "OK")
            if wss != nil {
                alert.addButton(withTitle: "Reconnect")
                alert.addButton(withTitle: "Force reconnect")
            }
            alert.alertStyle = .warning
            guard let window = NSApplication.shared.mainWindow else { return }
            alert.beginSheetModal(for: window) { res in
                if res == .alertSecondButtonReturn {
                    wss?.reset()
                } else if res == .alertThirdButtonReturn {
                    wss?.hardReset()
                }
            }
        }
    }
}

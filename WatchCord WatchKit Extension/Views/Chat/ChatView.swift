//
//  ChatView.swift
//  WatchCord WatchKit Extension
//
//  Created by Lakhan Lothiyi on 22/05/2022.
//

import Foundation
import SwiftUI

struct ChatView: View {
    
    @Binding var currentGuild: String
    @Binding var currentChannel: String
    
//    @StateObject var viewModel: ChannelViewModel
    
    var body: some View {
        if currentGuild == "2" {
            
            switch currentChannel {
            case "1":
                splash
            default:
                EmptyView()
            }
            
        } else {
            // Chat view
            VStack {
                Text(currentGuild)
                Text(currentChannel)
            }
        }
    }
    
    
    
    
    // MARK: - Settings
    
    @AppStorage("Explicit Splash Messages") var explicitSplashMessages = UserDefaults.standard.bool(forKey: "Explicit Splash Messages")
    
    @ViewBuilder
    var splash: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Splash Settings")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Button {} label: {
                    Toggle(isOn: $explicitSplashMessages) {
                        Text("Explicit Splash Messages")
                            .lineLimit(2)
                            .minimumScaleFactor(0.1)
                    }
                }
                Text("Some splash messages can have generally bad language. If you don't like mean stuff, keep this off.")
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
        }
    }
}

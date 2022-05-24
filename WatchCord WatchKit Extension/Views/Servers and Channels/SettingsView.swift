//
//  SettingsView.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 23/05/2022.
//

import SwiftUI

struct SettingsView: View {
    var user: User
    var settings: DiscordSettings
    
    @Binding var currentGuild: String
    @Binding var currentChannel: String
    
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("Heyo, \(user.username)!")
                    .font(.title3)
                Spacer()
            }
            Divider()
            HStack {
                Text("WatchCord Settings")
                    .foregroundColor(.secondary)
                    .font(.footnote)
                    .padding(.top, 5)
                Spacer()
            }
            Button {
                currentGuild = "2"
                currentChannel = "splash"
                
                withAnimation(.easeInOut) {
                    tabSelection = 2
                }
            } label: {
                HStack {
                    Text("Splash Settings")
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

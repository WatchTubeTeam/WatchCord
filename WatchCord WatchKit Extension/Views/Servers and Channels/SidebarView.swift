//
//  ContentView.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 15/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct SidebarView: View {
    
    var SelfUser: GatewayD
    
    @State var tabSelection = 1
    
    @State var selectedGuild: String = "0"
    @State var currentGuild: String = "0"
    @State var currentChannel: String = "0"

    var body: some View {
        TabView(selection: $tabSelection) {
            GeometryReader { geo in
                let guilds = SelfUser.guilds
                VStack {
                    HStack(spacing: 0) {
                        ScrollView {
                            VStack {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        currentGuild = "1"
                                    }
                                } label: {
                                    Image("dms")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()
                                        .cornerRadius(currentGuild == "1" ? 10 : 100)
                                }
                                .buttonStyle(.plain)
                                
                                Divider()
                                
                                ForEach(
                                    guilds.sorted(by: { a, b in
                                        a.index ?? 0 < b.index ?? 0
                                    })
                                ) { guild in
                                    GuildButton(guild: guild, currentGuild: $currentGuild)
                                }
                                
                                Divider()
                                
                                UserButton(user: SelfUser, currentGuild: $currentGuild)
                            }
                        }
                        .frame(width: geo.size.width * 0.20)
                        Spacer()
                        ScrollView {
                            VStack {
                                if currentGuild == "0" {
                                    // MARK: - Welcome Screen
                                    WelcomeView()
                                } else if currentGuild == "1" {
                                    // MARK: - Direct Messages
                                    DmsView(channels: SelfUser.private_channels, users: SelfUser.users, currentGuild: $currentGuild, currentChannel: $currentChannel, tabSelection: $tabSelection)
                                } else if currentGuild == "2" {
                                    SettingsView(user: SelfUser.user, settings: SelfUser.user_settings!, selectedGuild: $selectedGuild, currentGuild: $currentGuild, currentChannel: $currentChannel, tabSelection: $tabSelection)
                                } else {
                                    // MARK: - Guild View
                                    GuildView(guilds: SelfUser.guilds, tabSelection: $tabSelection, selectedGuild: $selectedGuild, currentGuild: $currentGuild, currentChannel: $currentChannel)
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.75)
                    }
                }
            }
            .navigationBarHidden(true)
            .tag(1)
            
            ChatView(currentGuild: $selectedGuild, currentChannel: $currentChannel)
                .navigationBarHidden(false)
                .tag(2)
        }
    }
}


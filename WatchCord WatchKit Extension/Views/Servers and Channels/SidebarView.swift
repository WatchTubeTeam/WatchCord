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
                                    if currentGuild == "1" {
                                        Image("WatchCord")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } else {
                                        Image("WatchCord")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .scaledToFit()
                                            .clipShape(Circle())
                                    }
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
                                    Text("Unfinished")
                                } else {
                                    // MARK: - Guild View
                                    GuildView(guilds: SelfUser.guilds, tabSelection: $tabSelection, currentGuild: $currentGuild, currentChannel: $currentChannel)
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.75)
                    }
                }
            }
            .navigationBarHidden(true)
            .tag(1)
            
            ChatView(currentGuild: $currentGuild, currentChannel: $currentChannel)
                .navigationBarHidden(false)
                .tag(2)
        }
    }
}


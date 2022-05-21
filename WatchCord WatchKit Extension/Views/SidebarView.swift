//
//  ContentView.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 15/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct SidebarView: View {
    
    var guilds: [Guild]
    
    @State var tabSelection = 1
    
    @State var currentGuild: String = "0"
    
    var body: some View {
        TabView(selection: $tabSelection) {
            GeometryReader { geo in
                VStack {
                    HStack(spacing: 0) {
                        ScrollView {
                            VStack {
                                Button {
                                    currentGuild = "1"
                                } label: {
                                    Image("WatchCord")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                                
                                Divider()
                                
                                ForEach(guilds) { guild in
                                    Button {
                                        currentGuild = guild.id
                                    } label: {
                                        let img = "\(cdnURL)/icons/\(guild.id)/\(guild.icon ?? "").png"
                                        if guild.id == currentGuild {
                                            WebImage(url: URL(string: guild.icon != nil ? img : "https://github.com/WatchTubeTeam/WatchCord/blob/cc9083d32931429678db61fb65e9ddbfb499482c/junk/missing.png"))
                                                .placeholder {
                                                    ProgressView()
                                                }
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        } else {
                                            WebImage(url: URL(string: guild.icon != nil ? img : "https://github.com/WatchTubeTeam/WatchCord/blob/cc9083d32931429678db61fb65e9ddbfb499482c/junk/missing.png"))
                                                .placeholder {
                                                    ProgressView()
                                                }
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .scaledToFit()
                                                .clipShape(Circle())
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                                
                                Divider()
                                Button {
                                    currentGuild = "2"
                                } label: {
                                    Image("WatchCord")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(width: geo.size.width * 0.20)
                        ScrollView {
                            
                        }
                        .frame(width: geo.size.width * 0.75)
                    }
                }
            }
            .tag(1)
            
            Text("gn")
                .tag(2)
        }
    }
}

struct old: View {
    
    @State var selectedServerId: String = "0"
    @State var selectedChannelId: String = "0"
    
    @State var servers: [dServer]! = Discord.myServers()
    @State var tabSelection = 1
        
    var body: some View {
        TabView(selection: $tabSelection) {
            GeometryReader { geometry in
                VStack {
                    HStack(spacing: 0) {
                        ScrollView {
                            VStack {
                                Button {
                                    selectedServerId = "1"
                                } label: {
                                    Image("WatchCord")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                                
                                Divider()
                                if servers != nil {
                                    ForEach(0..<servers.count, id: \.self) {i in
                                        let server = servers[i]
                                        Button {
                                            selectedServerId = server.id
                                        } label: {
                                            WebImage(url: URL(string: server.image))
                                                .placeholder {
                                                    ProgressView()
                                                }
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .scaledToFit()
                                                .clipShape(Circle())
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(width: geometry.size.width * 0.20)
                        Spacer()
                        if selectedServerId == "0" {
                            // welcome menu
                            VStack {
                                HStack {
                                    Text("Welcome to \nWatchCord!")
                                        .font(.callout)
                                        .minimumScaleFactor(0.1)
                                        .lineLimit(2)
                                    Spacer()
                                }
                                HStack {
                                    Text("Open a server to get started")
                                        .lineLimit(2)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .minimumScaleFactor(0.1)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .frame(width: geometry.size.width * 0.75)
                        } else if selectedServerId == "1" {
                            // dms
                            ScrollView {
                                VStack {
                                    HStack {
                                        Text("Direct Messages")
                                            .font(.callout)
                                            .minimumScaleFactor(0.1)
                                            .lineLimit(2)
                                        Spacer()
                                    }
                                    ForEach(0..<Discord.testUserData.count, id: \.self) { i in
                                        let user = Discord.testUserData[i]
                                        Button {
                                            selectedServerId = "1"
                                            selectedChannelId = user.id
                                            withAnimation(.easeInOut) {
                                                tabSelection = 2
                                            }
                                        } label: {
                                            HStack {
                                                WebImage(url: URL(string: user.thumb))
                                                    .placeholder {
                                                        ProgressView()
                                                            .progressViewStyle(.circular)
                                                    }
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Circle())
                                                    .frame(width: 30)
                                                Text(user.username)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.1)
                                                Spacer()
                                            }
                                        }

                                    }
                                    Spacer()
                                }
                                .frame(width: geometry.size.width * 0.75)
                            }
                            
                        } else {
                            // server view
                            ScrollView {
                                let data = Discord.server(selectedServerId)!
                                VStack {
                                    HStack {
                                        Text(data.name)
                                            .font(.title3)
                                        Spacer()
                                    }
                                    ForEach(0..<data.categories.count, id: \.self) { i in
                                        let category = data.categories[i]
                                        Section {
                                            ForEach(0..<category.channels.count, id: \.self) { xi in
                                                let channel = category.channels[xi]
                                                Button {
                                                    selectedChannelId = channel.id
                                                    withAnimation(.easeInOut) {
                                                        tabSelection = 2
                                                    }
                                                } label: {
                                                    HStack {
                                                        switch channel.type {
                                                        case .text:
                                                            Text(Image(systemName: "number"))
                                                                .font(.footnote)
                                                        case .voice:
                                                            Text(Image(systemName: "speaker.wave.2.fill"))
                                                                .font(.footnote)
                                                        case .stage:
                                                            Text(Image(systemName: "person.wave.2.fill"))
                                                                .font(.footnote)
                                                        case .announcement:
                                                            Text(Image(systemName: "megaphone.fill"))
                                                                .font(.footnote)
                                                        }
                                                        Text(channel.name)
                                                            .font(.footnote)
                                                            .lineLimit(1)
                                                            .minimumScaleFactor(0.5)
                                                        Spacer()
                                                    }
                                                }

                                            }
                                        } header: {
                                            HStack {
                                                Text(category.name)
                                                    .foregroundColor(.secondary)
                                                    .font(.footnote)
                                                Spacer()
                                            }
                                        }

                                    }
                                }
                            }
                            .frame(width: geometry.size.width * 0.75)
                        }
                    }
                }
            }
            .tag(1)
            ChatView(channelId: $selectedChannelId)
            .tag(2)
        }
        .navigationBarHidden(true)
    }
}

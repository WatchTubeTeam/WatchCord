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
                                    withAnimation(.easeInOut) {
                                        currentGuild = "1"
                                    }
                                } label: {
                                    Image("WatchCord")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()
                                        .clipShape(Circle())
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
                                Button {
                                    withAnimation(.easeInOut) {
                                        currentGuild = "2"
                                    }
                                } label: {
                                    let img = "\(cdnURL)/avatars/\(User.user.id)/\(SelfUser.user.avatar ?? "").png"
                                    if currentGuild == "2" {
                                        WebImage(url: URL(string: SelfUser.user.avatar != nil ? img : placeholders.avatar()))
                                            .placeholder {
                                                ProgressView()
                                            }
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } else {
                                        WebImage(url: URL(string: SelfUser.user.avatar != nil ? img : placeholders.avatar()))
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
                        }
                        .frame(width: geo.size.width * 0.20)
                        Spacer()
                        ScrollView {
                            VStack {
                                if currentGuild == "0" {
                                    // MARK: - Welcome Screen
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
                                } else if currentGuild == "1" {
                                    // MARK: - Direct Messages
                                    DmsView(channels: SelfUser.private_channels, users: SelfUser.users, currentGuild: $currentGuild, currentChannel: $currentChannel)
                                } else {
                                    // MARK: - Guild View
                                    GuildView(guilds: SelfUser.guilds, currentGuild: $currentGuild, currentChannel: $currentChannel)
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.75)
                    }
                }
            }
            .navigationBarHidden(true)
            .tag(1)
            
            Text("gn")
                .navigationBarHidden(false)
                .tag(2)
        }
    }
}


//
//struct old: View {
//
//    @State var selectedServerId: String = "0"
//    @State var selectedChannelId: String = "0"
//
//    @State var servers: [dServer]! = Discord.myServers()
//    @State var tabSelection = 1
//
//    var body: some View {
//        TabView(selection: $tabSelection) {
//            GeometryReader { geometry in
//                VStack {
//                    HStack(spacing: 0) {
//                        ScrollView {
//                            VStack {
//                                Button {
//                                    selectedServerId = "1"
//                                } label: {
//                                    Image("WatchCord")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .scaledToFit()
//                                        .clipShape(Circle())
//                                }
//                                .buttonStyle(.plain)
//
//                                Divider()
//                                if servers != nil {
//                                    ForEach(0..<servers.count, id: \.self) {i in
//                                        let server = servers[i]
//                                        Button {
//                                            selectedServerId = server.id
//                                        } label: {
//                                            WebImage(url: URL(string: server.image))
//                                                .placeholder {
//                                                    ProgressView()
//                                                }
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .scaledToFit()
//                                                .clipShape(Circle())
//                                        }
//                                        .buttonStyle(.plain)
//                                    }
//                                }
//                                Spacer()
//                            }
//                        }
//                        .frame(width: geometry.size.width * 0.20)
//                        Spacer()
//                        if selectedServerId == "0" {
//                            // welcome menu
//                            VStack {
//                                HStack {
//                                    Text("Welcome to \nWatchCord!")
//                                        .font(.callout)
//                                        .minimumScaleFactor(0.1)
//                                        .lineLimit(2)
//                                    Spacer()
//                                }
//                                HStack {
//                                    Text("Open a server to get started")
//                                        .lineLimit(2)
//                                        .font(.footnote)
//                                        .foregroundColor(.secondary)
//                                        .minimumScaleFactor(0.1)
//                                    Spacer()
//                                }
//                                Spacer()
//                            }
//                            .frame(width: geometry.size.width * 0.75)
//                        } else if selectedServerId == "1" {
//                            // dms
//                            ScrollView {
//                                VStack {
//                                    HStack {
//                                        Text("Direct Messages")
//                                            .font(.callout)
//                                            .minimumScaleFactor(0.1)
//                                            .lineLimit(2)
//                                        Spacer()
//                                    }
//                                    ForEach(0..<Discord.testUserData.count, id: \.self) { i in
//                                        let user = Discord.testUserData[i]
//                                        Button {
//                                            selectedServerId = "1"
//                                            selectedChannelId = user.id
//                                            withAnimation(.easeInOut) {
//                                                tabSelection = 2
//                                            }
//                                        } label: {
//                                            HStack {
//                                                WebImage(url: URL(string: user.thumb))
//                                                    .placeholder {
//                                                        ProgressView()
//                                                            .progressViewStyle(.circular)
//                                                    }
//                                                    .resizable()
//                                                    .aspectRatio(contentMode: .fit)
//                                                    .clipShape(Circle())
//                                                    .frame(width: 30)
//                                                Text(user.username)
//                                                    .lineLimit(1)
//                                                    .minimumScaleFactor(0.1)
//                                                Spacer()
//                                            }
//                                        }
//
//                                    }
//                                    Spacer()
//                                }
//                                .frame(width: geometry.size.width * 0.75)
//                            }
//
//                        } else {
//                            // server view
//                            ScrollView {
//                                let data = Discord.server(selectedServerId)!
//                                VStack {
//                                    HStack {
//                                        Text(data.name)
//                                            .font(.title3)
//                                        Spacer()
//                                    }
//                                    ForEach(0..<data.categories.count, id: \.self) { i in
//                                        let category = data.categories[i]
//                                        Section {
//                                            ForEach(0..<category.channels.count, id: \.self) { xi in
//                                                let channel = category.channels[xi]
//                                                Button {
//                                                    selectedChannelId = channel.id
//                                                    withAnimation(.easeInOut) {
//                                                        tabSelection = 2
//                                                    }
//                                                } label: {
//                                                    HStack {
//                                                        switch channel.type {
//                                                        case .text:
//                                                            Text(Image(systemName: "number"))
//                                                                .font(.footnote)
//                                                        case .voice:
//                                                            Text(Image(systemName: "speaker.wave.2.fill"))
//                                                                .font(.footnote)
//                                                        case .stage:
//                                                            Text(Image(systemName: "person.wave.2.fill"))
//                                                                .font(.footnote)
//                                                        case .announcement:
//                                                            Text(Image(systemName: "megaphone.fill"))
//                                                                .font(.footnote)
//                                                        }
//                                                        Text(channel.name)
//                                                            .font(.footnote)
//                                                            .lineLimit(1)
//                                                            .minimumScaleFactor(0.5)
//                                                        Spacer()
//                                                    }
//                                                }
//
//                                            }
//                                        } header: {
//                                            HStack {
//                                                Text(category.name)
//                                                    .foregroundColor(.secondary)
//                                                    .font(.footnote)
//                                                Spacer()
//                                            }
//                                        }
//
//                                    }
//                                }
//                            }
//                            .frame(width: geometry.size.width * 0.75)
//                        }
//                    }
//                }
//            }
//            .tag(1)
//            ChatView(channelId: $selectedChannelId)
//            .tag(2)
//        }
//        .navigationBarHidden(true)
//    }
//}

struct GuildButton: View {
    var guild: Guild
    @Binding var currentGuild: String
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                currentGuild = guild.id
            }
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
}

struct GuildView: View {
    
    var guilds: [Guild]
    @Binding var currentGuild: String
    @Binding var currentChannel: String

    var body: some View {
        let guild = guilds.filter { $0.id == currentGuild }.first
        if guild != nil {
            HStack {
                Text(guild.name!)
                    .font(.title3)
                Spacer()
            }
            ForEach(guild.channels ?? .init(), id: \.id) { channel in
                if channel.type == .section {
                    Text(channel.name?.uppercased() ?? "")
                        .fontWeight(.bold)
                        .foregroundColor(Color.secondary)
                        .font(.footnote)
                } else {
                    Button {
                        currentGuild = guild.id
                        currentChannel = channel.id
                    } label: {
                        HStack {
                            switch channel.type {
                            case .normal:
                                Image(systemName: "number")
                            default:
                                Image(systemName: "questionmark.square.dashed")
                            }
                        }
                    }

                }
            }
        }
    }
}

struct DmsView: View {
    @State var channels: [Channel]
    @State var users: [User]
    
    @Binding var currentGuild: String
    @Binding var currentChannel: String
    
    var body: some View {
        HStack {
            Text("Direct Messages")
                .font(.callout)
                .minimumScaleFactor(0.1)
                .lineLimit(2)
            Spacer()
        }
        ForEach(channels) { dm in
            let person = users.filter { $0.id == dm.recipient_ids?.first }.first!
            let avatarurl = person.avatar == nil ? placeholders.avatar() : "\(cdnURL)/avatars/\(person.id)/\(person.avatar ?? "").png"
            Button {
                currentGuild = "1"
                currentChannel = dm.id
                withAnimation(.easeInOut) {
                    tabSelection = 2
                }
            } label: {
                HStack {
                    WebImage(url: URL(string: avatarurl))
                        .placeholder {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 30)
                    Text(person.username)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Spacer()
                }
            }

        }
        Spacer()
    }
}

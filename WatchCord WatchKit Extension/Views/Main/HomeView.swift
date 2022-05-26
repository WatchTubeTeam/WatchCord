//
//  HomeView.swift
//  WatchCord
//
//  Created by Lakhan Lothiyi on 26/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    var UserData: GatewayD
        
    @State var homeControl = 0
    // 0 is welcome view
    // 1 is dms
    // 2 is guild
    // 3 is settings
    
    @State var selectedGuild: Guild! = nil
        
    var body: some View {
        NavigationView {
            
            // MARK: - Destination Selection
            
            GeometryReader { geo in
                VStack {
                    HStack(spacing: 0) {
                        let guilds = UserData.guilds
                        
                        ScrollView {
                            // MARK: - Servers Sidebar
                            
                            VStack {
                                // MARK: DMs button
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedGuild = nil
                                        homeControl = 1
                                    }
                                } label: {
                                    Image("dms")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()
                                        .cornerRadius(homeControl == 1 ? 10 : 100)
                                }
                                .buttonStyle(.plain)
                                
                                Divider()
                                
                                ForEach(
                                    guilds.sorted(by: { a, b in
                                        a.index ?? 0 < b.index ?? 0
                                    })
                                ) { guild in
                                    GuildButton(guild: guild, selectedGuild: $selectedGuild, homeControl: $homeControl)
                                }
                                
                                Divider()
                                
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedGuild = nil
                                        homeControl = 3
                                    }
                                } label: {
                                    let img = "\(cdnURL)/avatars/\(UserData.user.id)/\(UserData.user.avatar ?? "").png"
                                    WebImage(url: URL(string: UserData.user.avatar != nil ? img : placeholders.avatar(UserData.user.discriminator)))
                                        .placeholder {
                                            ProgressView()
                                        }
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()
                                        .cornerRadius(homeControl == 3 ? 10 : 100)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(width: geo.size.width * 0.20)
                        
                        Spacer()
                        
                        ScrollView {
                            // MARK: - Selected Guild View
                            
                            VStack {
                                switch homeControl {
                                case 0:
                                    welcome
                                case 1:
                                    DmsView(channels: UserData.private_channels, users: UserData.users, selectedGuild: $selectedGuild)
                                case 2:
                                    GuildView(selectedGuild: $selectedGuild)
                                case 3:
                                    settings
                                default:
                                    Text("Something's gone wrong!")
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.75)
                    }
                }
            }
            
            NavigationLink(isActive: $chatShown) {
                ChatView(chatShown: $chatShown, currentChannel: $currentChannel)
            } label: {}
                .buttonStyle(.plain)
        }
        .navigationBarHidden(true)
    }
    
    
    var welcome: some View {
        VStack {
            HStack {
                Text("Welcome to\nWatchCord!")
                    .font(.callout)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
                Image("WatchCord")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .clipShape(Circle())
            }
            HStack {
                Text("Choose a chat to start!")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
    
    @AppStorage("Explicit Splash Messages") var explicitSplashMessages = UserDefaults.standard.bool(forKey: "Explicit Splash Messages")
    @AppStorage("Compact Chat UI") var compactchatui = UserDefaults.standard.bool(forKey: "Compact Chat UI")

    var settings: some View {
        VStack {
            HStack {
                Text("Heyo, \(UserData.user.username)!")
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
            Button {} label: {
                Toggle(isOn: $explicitSplashMessages) {
                    Text("Explicit Splash Messages")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.1)
                }
            }
            Text("Some splash messages can have generally bad language. If you don't like mean stuff, keep this off.")
                .foregroundColor(.secondary)
                .font(.footnote)
            Button {} label: {
                Toggle(isOn: $compactchatui) {
                    Text("Compact Chat UI")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.1)
                }
            }
            Text("Basically remove anything unnecessary from the UI so you can fit more messages, also fixes chat font at a smaller font size.")
                .foregroundColor(.secondary)
                .font(.footnote)
        }
    }
}

extension GatewayD {
    func order() {
        let showHiddenChannels = false
        guilds.enumerated().forEach { index, _guild in
            var guild = _guild
            guild.channels = guild.channels?.sorted { ($0.type.rawValue, $0.position ?? 0, $0.id) < ($1.type.rawValue, $1.position ?? 0, $1.id) }
            guard let rejects = guild.channels?
                .filter({ $0.parent_id == nil && $0.type != .section }),
                let parents: [Channel] = guild.channels?.filter({ $0.type == .section }),
                let sections = Array(NSOrderedSet(array: parents)) as? [Channel] else { return }
            var sectionFormatted: [Channel] = .init()
            sections.forEach { channel in
                guard let matching = guild.channels?
                    .filter({ $0.parent_id == channel.id })
                    .filter({ showHiddenChannels ? true : ($0.shown ?? true) }),
                    !matching.isEmpty else { return }
                sectionFormatted.append(channel)
                sectionFormatted.append(contentsOf: matching)
            }
            var threadFormatted: [Channel] = .init()
            sectionFormatted.forEach { channel in
                guard let matching = guild.threads?.filter({ $0.parent_id == channel.id }) else { return }
                threadFormatted.append(channel)
                threadFormatted.append(contentsOf: matching)
            }
            threadFormatted.insert(contentsOf: rejects, at: 0)
            guild.channels = threadFormatted
            self.guilds[index] = guild
        }
    }
}

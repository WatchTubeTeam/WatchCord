//
//  GuildView.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 22/05/2022.
//

import SwiftUI

struct GuildView: View {
    
    var guilds: [Guild]
    @Binding var tabSelection: Int
    @Binding var currentGuild: String
    @Binding var currentChannel: String

    @State private var error = false
    
    var body: some View {
        let guild = guilds.filter { $0.id == currentGuild }.first
        if guild != nil {
            HStack {
                Text((guild?.name!)!)
                    .font(.title3)
                Spacer()
            }
            
            ForEach(guild?.channels ?? .init(), id: \.id) { channel in
                if channel.shown == false { EmptyView() } else {
                    if channel.type == .section {
                        // MARK: - Categories are channels too

                        HStack {
                            Text(channel.name?.uppercased() ?? "")
                                .fontWeight(.bold)
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.top, 5)
                    } else {
                        // MARK: - Channel
                        
                        Button {
                            switch channel.type {
                            case .normal:
                                withAnimation(.easeInOut) {
                                    currentGuild = guild!.id
                                    currentChannel = channel.id
                                    tabSelection = 2
                                }
                            case .voice:
                                error.toggle()
                            case .guild_news:
                                error.toggle()
                            case .guild_store:
                                error.toggle()
                            case .stage:
                                error.toggle()
                            default:
                                error.toggle()
                            }
                        } label: {
                            HStack {
                                switch channel.type {
                                case .normal:
                                    Image(systemName: "number")
                                case .voice:
                                    Image(systemName: "speaker.wave.2.fill")
                                case .guild_news:
                                    Image(systemName: "megaphone.fill")
                                case .guild_store:
                                    Image(systemName: "dollarsign.circle")
                                case .stage:
                                    Image(systemName: "person.wave.2")
                                default:
                                    Image(systemName: "questionmark.square.dashed")
                                }
                                Text(channel.name ?? "Unknown")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                                Spacer()
                            }
                        }
                        .alert(isPresented: $error) {
                            Alert(title: Text("Incomplete"), message: Text("We haven't added support for this kind of channel yet!"), dismissButton: .default(Text("Got it!")))
                        }
                    }
                }
            }
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

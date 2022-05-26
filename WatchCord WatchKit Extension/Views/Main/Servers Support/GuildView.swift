//
//  GuildView.swift
//  WatchCord
//
//  Created by Lakhan Lothiyi on 26/05/2022.
//

import SwiftUI

struct GuildView: View {
    
    @Binding var tabSelection: Int
    @Binding var selectedGuild: Guild!
    @Binding var currentGuild: Guild!
    @Binding var currentChannel: Channel!

    @State private var error = false
    
    var body: some View {
        if let guild = selectedGuild {
            HStack {
                Text(guild.name!)
                    .font(.title3)
                Spacer()
            }
            
            ForEach(guild.channels ?? .init(), id: \.id) { channel in
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
                                    currentGuild = guild
                                    selectedGuild = guild
                                    currentChannel = channel
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
        } else {
            Text("Something's gone really wrong and we don't have any guild data right now.")
        }
    }
}

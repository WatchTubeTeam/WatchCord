//
//  GuildView.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 22/05/2022.
//

import SwiftUI

struct GuildView: View {
    
    var guilds: [Guild]
    @Binding var currentGuild: String
    @Binding var currentChannel: String

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
                        HStack {
                            Text(channel.name?.uppercased() ?? "")
                                .fontWeight(.bold)
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                                .lineLimit(1)
                            Spacer()
                        }
                    } else {
                        Button {
                            currentGuild = guild!.id
                            currentChannel = channel.id
                        } label: {
                            HStack {
                                switch channel.type {
                                case .normal:
                                    Image(systemName: "number")
                                case .voice:
                                    Image(systemName: "speaker.wave.2")
                                case .guild_news:
                                    Image(systemName: "megaphone")
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
                    }
                }
            }
        }
    }
}

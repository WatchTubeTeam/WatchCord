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
                if channel.type == .section {
                    Text(channel.name?.uppercased() ?? "")
                        .fontWeight(.bold)
                        .foregroundColor(Color.secondary)
                        .font(.footnote)
                } else {
                    Button {
                        currentGuild = guild!.id
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

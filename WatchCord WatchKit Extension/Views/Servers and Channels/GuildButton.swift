//
//  GuildButton.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 22/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct GuildButton: View {
    var guild: Guild
    @Binding var currentGuild: String
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
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

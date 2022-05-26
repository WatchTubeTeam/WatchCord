//
//  GuildButton.swift
//  WatchCord
//
//  Created by Lakhan Lothiyi on 26/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct GuildButton: View {
    
    var guild: Guild!
    @Binding var selectedGuild: Guild!
    @Binding var homeControl: Int

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                homeControl = 2
                selectedGuild = guild
            }
        } label: {
            let img = "\(cdnURL)/icons/\(guild.id)/\(guild.icon ?? "").png"
            WebImage(url: URL(string: guild.icon != nil ? img : "https://github.com/WatchTubeTeam/WatchCord/blob/cc9083d32931429678db61fb65e9ddbfb499482c/junk/missing.png"))
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .cornerRadius(selectedGuild == guild ? 10 : 100)
        }
        .buttonStyle(.plain)
    }
}

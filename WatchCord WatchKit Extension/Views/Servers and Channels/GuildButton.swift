//
//  GuildButton.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 22/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct GuildButton: View {
    var guild: Guild!
    @Binding var currentGuild: String
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentGuild = guild.id
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
                .cornerRadius(guild.id == currentGuild ? 10 : 100)
        }
        .buttonStyle(.plain)
    }
}

struct guildbuttontest: PreviewProvider {
    static var previews: some View {
        let guild = Guild(id: "834810916692033536", name: "test", icon: "403ffe2df286e8e49bd94bbe608f268b", icon_hash: "", owner: true, owner_id: "381538809180848128", roles: [], emojis: [], mfa_level: 0, large: false, unavailable: false, member_count: 95, channels: [], threads: [], max_presences: 1, max_members: 1, vanity_url_code: "", description: "", banner: "", premium_tier: 0, premium_subscription_count: 0, approximate_member_count: 90, approximate_presence_count: 20, nsfw_level: 0, index: 1, mergedMember: nil, guildPermissions: "")
        GeometryReader { geo in
            GuildButton(guild: guild, currentGuild: .constant("834810916692033536"))
                .frame(width: geo.size.width * 0.20)
        }
    }
}

//
//  UserButton.swift
//  WatchCord WatchKit Extension
//
//  Created by Lakhan Lothiyi on 22/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserButton: View {
    
    var user: GatewayD
    
    @Binding var currentGuild: String
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentGuild = "2"
            }
        } label: {
            let img = "\(cdnURL)/avatars/\(user.user.id)/\(user.user.avatar ?? "").png"
            WebImage(url: URL(string: user.user.avatar != nil ? img : placeholders.avatar(user.user.discriminator)))
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .cornerRadius(currentGuild == "2" ? 10 : 100)
        }
        .buttonStyle(.plain)
    }
}

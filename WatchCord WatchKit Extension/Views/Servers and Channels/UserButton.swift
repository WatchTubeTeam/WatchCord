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
            if currentGuild == "2" {
                WebImage(url: URL(string: user.user.avatar != nil ? img : placeholders.avatar()))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                WebImage(url: URL(string: user.user.avatar != nil ? img : placeholders.avatar()))
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

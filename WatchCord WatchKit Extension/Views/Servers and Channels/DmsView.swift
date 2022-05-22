//
//  DmsView.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 22/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DmsView: View {
    @State var channels: [Channel]
    @State var users: [User]
    
    @Binding var currentGuild: String
    @Binding var currentChannel: String
    @Binding var tabSelection: Int

    var body: some View {
        HStack {
            Text("Direct Messages")
                .font(.callout)
                .minimumScaleFactor(0.1)
                .lineLimit(2)
            Spacer()
        }
        ForEach(channels) { dm in
            let person = users.filter { $0.id == dm.recipient_ids?.first }.first!
            let avatarurl = person.avatar == nil ? placeholders.avatar() : "\(cdnURL)/avatars/\(person.id)/\(person.avatar ?? "").png"
            Button {
                currentGuild = "1"
                currentChannel = dm.id
                withAnimation(.easeInOut(duration: 0.2)) {
                    tabSelection = 2
                }
            } label: {
                HStack {
                    WebImage(url: URL(string: avatarurl))
                        .placeholder {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 30)
                    Text(person.username)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    Spacer()
                }
            }

        }
        Spacer()
    }
}

//
//  ChatView.swift
//  WatchCord
//
//  Created by Lakhan Lothiyi on 26/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatView: View {
    @State private var channelHeader = true
    
    var channel: Channel
    var guild: Guild!
    @StateObject var viewmodel: ChannelViewModel
    
    init(_ channel: Channel, _ guild: Guild!) {
        self.guild = guild
        self.channel = channel
        guildID = channel.guild_id ?? "@me"
        channelID = channel.id
        if let _ = channel.name {
            channelName = channel.name ?? AccordCoreVars.users?.filter({$0.id == channel.recipient_ids?.first}).first?.username ?? "Unknown"
        } else {
            channelName = channel.name ?? AccordCoreVars.users?.filter({$0.id == channel.recipient_ids?.first}).first?.username ?? "Unknown"
            channelName = String(channelName.dropFirst(channelName.count))
        }
        if let server = guild {
            self.guildName = server.name ?? "DMs"
        } else {
            self.guildName = "DMs"
        }
        _viewmodel = StateObject(wrappedValue: ChannelViewModel(channel: channel))
        _memberList = State(initialValue: channel.recipients?.map(OPSItems.init) ?? [])
    }
    
    
    var guildID: String
    var channelID: String
    var channelName: String
    var guildName: String

    // Whether or not there is a message send in progress
    @State var sending: Bool = false

    // Nicknames/Usernames of users typing
    @State var typing: [String] = []

    // WebSocket error
    @State var error: String?

    // Mention users in replies
    @State var mention: Bool = true
    @State var replyingTo: Message?
    @State var mentionUser: Bool = true

    @State var pins: Bool = false
    @State var mentions: Bool = false
    
    @State var memberList: [OPSItems]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(viewmodel.messages, id: \.identifier) { message in
                    msgCell(msg: message)
                    .id(message.id)
                    .listRowInsets(.init(top: 3.5, leading: 0, bottom: 5, trailing: 0))
                    .padding(.horizontal, 5)
                    .padding(.vertical, (message.user_mentioned == nil ? false : true) == true ? 3 : 0)
//                    .background((message.user_mentioned == nil ? false : true) == true ? Color.yellow.opacity(0.1).cornerRadius(7) : nil)
                    .onAppear {
                        if viewmodel.messages.count >= 50,
                           message == viewmodel.messages[viewmodel.messages.count - 2]
                        {
                            messageFetchQueue.async {
                                viewmodel.loadMoreMessages()
                            }
                        }
                    }
                    .flippedUpsideDown()
            }
            //
        }
        .flippedUpsideDown()
        .listStyle(.plain)
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(channelName)
    }
}

struct FlippedUpsideDown: ViewModifier {
   func body(content: Content) -> some View {
    content
           .rotationEffect(.degrees(180))
      .scaleEffect(x: -1, y: 1, anchor: .center)
   }
}
extension View{
   func flippedUpsideDown() -> some View{
     self.modifier(FlippedUpsideDown())
   }
}

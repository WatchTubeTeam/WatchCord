//
//  ChatView.swift
//  WatchCord
//
//  Created by Lakhan Lothiyi on 26/05/2022.
//

import SwiftUI

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
        channelName = channel.name ?? channel.recipients?.first?.username ?? "Unknown channel"
        self.guildName = guild.name ?? "Direct Messages"
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
        ZStack {
            VStack {
                if channelHeader {
                    HStack {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                        .padding(4)

                        Text("#\(channel.name ?? "Channel")")
                        Spacer()
                        Text(guild.name ?? "Server")
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .padding()
                    .background(Capsule(style: .continuous).foregroundColor(.gray).opacity(0.2))
                    .frame(height: WKInterfaceDevice.current().screenBounds.height / 20)
                } else {
                    HStack {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                        .padding(4)
                        .background(Capsule(style: .continuous).foregroundColor(.gray).opacity(0.2))
                        
                        Text("#\(channel.name ?? "Channel")")
                            .opacity(0)
                        Spacer()
                        Text(guild.name ?? "Server")
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .opacity(0)

                    }
                    .padding()
                    .background(
                        Capsule(style: .continuous).foregroundColor(.gray)
                            .opacity(0.001)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.2)) {
                                    channelHeader = true
                                }
                                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        channelHeader = false
                                    }
                                }
                            }
                    )
                    .frame(height: WKInterfaceDevice.current().screenBounds.height / 20)
                }
                Spacer()
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        channelHeader = false
                    }
                }
            }
            
        }
        .onAppear {
            channelHeader = true
        }
        .navigationBarHidden(true)
    }
}

//struct chatdesign: PreviewProvider {
//    static var previews: some View {
//        let chnl = Channel(id: "123", type: .normal, position: 1, parent_id: "123")
//        ChatView(tabSelection: .constant(2), currentChannel: .constant(chnl))
//    }
//}

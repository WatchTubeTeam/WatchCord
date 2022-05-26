//
//  ChatView.swift
//  WatchCord
//
//  Created by Lakhan Lothiyi on 26/05/2022.
//

import SwiftUI

struct ChatView: View {
    
    @Binding var tabSelection: Int
    @Binding var currentChannel: Channel!
    
    @State private var channelHeader = true
    
    @StateObject var viewmodel: ChannelViewModel
    
    init(tabSelection: Binding<Int>, currentChannel: Binding<Channel?>) {
        _tabSelection = tabSelection
        _currentChannel = currentChannel
        _viewmodel = StateObject(wrappedValue: ChannelViewModel(channel: currentChannel.wrappedValue ?? Channel(id: "123", type: .normal, position: 0, parent_id: "123")))
    }
    
    var body: some View {
        if let channel = currentChannel {
            if channel.id != "123" && channel.parent_id != "123" {
                ZStack {
                    if channelHeader {
                        VStack {
                            HStack {
                                Button {
                                    withAnimation(.easeInOut) {
                                        tabSelection = 1
                                    }
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.accentColor)
                                }
                                .buttonStyle(.plain)
                                
                                Text("#\(channel.name ?? "Channel")")
                                Spacer()
                                Text(channel.guild_name ?? "Server")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            .padding()
                            .background(Capsule(style: .continuous).foregroundColor(.gray).opacity(0.2))
                            .frame(height: WKInterfaceDevice.current().screenBounds.height / 20)
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
                    
                }
                .onAppear {
                    channelHeader = true
                }
            } else {
                Text("heyo")
            }
        }
    }
}

//struct chatdesign: PreviewProvider {
//    static var previews: some View {
//        let chnl = Channel(id: "123", type: .normal, position: 1, parent_id: "123")
//        ChatView(tabSelection: .constant(2), currentChannel: .constant(chnl))
//    }
//}

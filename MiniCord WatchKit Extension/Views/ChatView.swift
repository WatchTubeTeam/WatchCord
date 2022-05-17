//
//  ChatView.swift
//  MiniCord WatchKit Extension
//
//  Created by llsc12 on 15/05/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import UIKit

struct ChatView: View {
    @State private var showScroll = false
    @State private var scrollToBottom = false
    @State private var txt: String = ""
    @Binding var channelId: String
    @State var chat: [dChatMessage] = [
        dChatMessage(user: "llsc12", content: "heyo people!", dateString: "Today at 17:41", reactions: [
            dReaction(id: "962859565358149642", isAnimated: true, count: 7, userReacted: false)
        ]),
        dChatMessage(user: "Superbro", content: "hey", dateString: "Today at 17:42", reactions: []),
        dChatMessage(user: "llsc12", content: "happy birbday to emy", dateString: "Today at 17:47", reactions: [
            dReaction(id: "753696990998823005", isAnimated: false, count: 2, userReacted: false),
            dReaction(id: "863237127931691018", isAnimated: false, count: 17, userReacted: true)
        ]),
        dChatMessage(user: "Hey Man", content: "hbd", dateString: "Today at 17:48", reactions: [])
    ]
    var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { reader in
                    VStack {
                        ForEach(0..<chat.count, id: \.self) { i in
                            message(chat: $chat, msg: chat[i])
                                .tag(i)
                        }
                        .onAppear {
                            reader.scrollTo(chat.count - 1, anchor: .center)
                        }
                        .onReceive(chat.publisher) { _ in
                            reader.scrollTo(chat.count - 1, anchor: .center)
                        }
                        .onChange(of: scrollToBottom) { _ in
                            print("scroll")
                            reader.scrollTo(chat.count - 1, anchor: .center)
                        }
                        TextField("Send Message...", text: $txt)
                            .onAppear {
                                showScroll = false
                            }
                            .onDisappear {
                                showScroll = true
                            }
                            .onSubmit {
                                let date = Date()
                                let dateformatter = DateFormatter()
                                dateformatter.dateFormat = "HH:mm"
                                let object = dChatMessage(user: "User", content: txt, dateString: "Today at \(dateformatter.string(from: date))", reactions: [])
                                chat.append(object)
                                txt = ""
                            }
                    }
                }
            }
            VStack {
                if showScroll {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            scrollToBottom.toggle()
                        } label: {
                            Circle()
                                .foregroundColor(.init(.displayP3, white: 0.1, opacity: 1))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "chevron.down")
                                }
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
            }
        }
    }
}


struct message: View {
    @Binding var chat: [dChatMessage]
    @State var msg: dChatMessage
    
    var body: some View {
        VStack {
            HStack {
                Text(msg.user)
                    .font(.subheadline)
                    .lineLimit(1)
                Text(msg.dateString)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Spacer()
            }
            HStack {
                Text(msg.content)
                    .font(.subheadline)
                Spacer()
            }
            if !msg.reactions.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<msg.reactions.count, id: \.self) { i in
                            Button {
                                // react to msg
                                let index = chat.firstIndex { $0.content == msg.content }
                                if index == nil {return}
                                let index2 = chat[index!].reactions.firstIndex { $0.id == msg.reactions[i].id}
                                if index2 == nil {return}
                                chat[index!].reactions[index2!].userReacted.toggle()
                            } label: {
                                HStack {
                                    Text(String(msg.reactions[i].count))
                                    WebImage(url: URL(string: "https://cdn.discordapp.com/emojis/\(msg.reactions[i].id).\(msg.reactions[i].isAnimated ? "gif" : "png")"))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background {
                                if msg.reactions[i].userReacted == false {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.init(.displayP3, white: 0.1, opacity: 1))
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(uiColor: UIColor(rgb: 0x3b415a)))
                                }
                            }
                        }
                    }
                }
                .frame(height: WKInterfaceDevice.current().screenBounds.height / 10)
            }
        }
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

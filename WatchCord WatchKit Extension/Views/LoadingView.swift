//
//  LoadingView.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 20/05/2022.
//

import WatchKit
import SwiftUI

struct TiltAnimation: ViewModifier {
    @State var rotated: Bool = false
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotated ? 10 : -10))
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                    withAnimation(Animation.spring()) {
                        rotated.toggle()
                    }
                }
            }
    }
}

struct LoadingView: View {
    
    @Binding var token: String
    
    @State private var logoutprompt = false
    @State private var done = false
    
    var body: some View {
        VStack {
            Image("WatchCord")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: WKInterfaceDevice.current().screenBounds.width / 3)
                .clipShape(Circle())
                .modifier(TiltAnimation())
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            logoutprompt = true
                        }
                    }
                }
            if !logoutprompt {
                quotes()
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
            } else {
                if done == false {
                    Text("Having issues?")
                    Button("Log Out") {
                        token = ""
                        UserDefaults.standard.set(nil, forKey: keychainItemName)
                        AccordCoreVars.token = ""
                        withAnimation(.easeInOut(duration: 0.2)) {
                            done = true
                        }
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("Relaunch and resync credentials")
                }
            }
        }
    }
}

fileprivate func quotes() -> Text {
    if Bool.random() && Bool.random() {
        let greetings: [Text] = [
            Text("Made in Canada!"),
            Text("Gaslight. Gatekeep. Girlboss.").italic(),
            Text("Not a car"),
            Text("Send feature requests in our server!"),
            Text("Originally written by ") + Text("evln#0001").font(Font.system(.body, design: .monospaced)),
            Text("Made by ") + Text("llsc12#1902").font(Font.system(.body, design: .monospaced)),
            Text(verbatim: #"¯\_(ツ)_/¯"#),
            Text("uwu owo"),
            Text("What's a X-Super-Properties?"),
            Text("😼"),
            Text("is this thing on?"),
            Text("They said they wouldn't make Accord Watch")
        ]
        return greetings.randomElement()!
    } else { // https://github.com/p0larisdev/app/blob/master/p0laris/Code/Garbage/quote.m thanks spv
        var array = [
            "y'all mind giving me some splashes?",
            "constant state of fear and misery",
            "out of context ooc",
            "insert injoke here",
            "insert witty stuff here",
            "meme machine meme machine",
            "lol jk",
            "it's about drive",
            "it's about power",
            "we stay hungry",
            "we devour",
            "spoiler alert",
            "the good guy usually lives",
            "it's just business fella",
            "it's been nearly 10 years",
            "you forget a thousand things everyday",
            "how 'bout you make sure this is one of em",
            "is this thing even on?",
            "what's the deal with airline food",
            "if only home depot was open source",
            "take that how you will",
            "quotes are rants but short",
            "wen eta",
            "drama is cringe",
            "cool mustache wario",
            "AI BMW water bottle",
            "127.0.0.1",
            "we out here",
            "зачем вы потрудились перевести это",
            "owo",
            "uwu",
            "fortnite battle pass",
            "hello world",
            "unmute llsc",
            
        ]
        let explicit = [
            "inject the memes into my bloodstream",
            "roses are red, violets are blue,\nfuck you",
            "ratshit batshit",
            "4 spaces or gtfo",
            "you guys are why i drink",
            "hi kids, do you like violence?",
            "guns go bang",
            "piss and shit",
            "i'm allergic to bullshit",
            "your mother",
            "cum cock balls",
            "cum",
            "stupid ass mf",
        ]
        if UserDefaults.standard.bool(forKey: "Explicit Splash Messages") {
            array.append(contentsOf: explicit)
            
            return Text(array.randomElement()!)
        } else {
            return Text(array.randomElement()!)
        }
    }
}

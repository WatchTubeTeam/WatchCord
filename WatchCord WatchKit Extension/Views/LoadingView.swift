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
    var body: some View {
        VStack {
            Image("WatchCord")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: WKInterfaceDevice.current().screenBounds.width / 3)
                .clipShape(Circle())
                .modifier(TiltAnimation())

            LoadingView.greetings.randomElement()!
        }
    }
    
    fileprivate static let greetings: [Text] = [
        Text("Made in Canada!"),
        Text("Gaslight. Gatekeep. Girlboss.").italic(),
        Text("Not a car"),
        Text("Send feature requests in our server!"),
        Text("Originally written by ") + Text("evln#0001").font(Font.system(.title2, design: .monospaced)),
        Text("You can change your nickname with ") + Text("/nick").font(Font.system(.title2, design: .monospaced)),
        Text(verbatim: #"¯\_(ツ)_/¯"#),
        Text("uwu owo"),
        Text("What's a X-Super-Properties?"),
        Text("😼"),
        Text("is this thing on?"),
        Text("They said they wouldn't make Accord Watch")
    ]
}

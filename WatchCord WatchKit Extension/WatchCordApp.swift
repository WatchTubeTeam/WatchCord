//
//  WatchCordApp.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 15/05/2022.
//

import SwiftUI

@main
struct WatchCordApp: App {
    
    @State var token = AccordCoreVars.token
    @State var loaded: Bool = false
    @State var popup: Bool = false

    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if self.token == "" {
                    // is not logged in
                    LoginView()
                }
            }
        }
    }
}

fileprivate struct LoginView: View {
    var body: some View {
        ZStack {
            Color(rgb: 0x1b274a)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    HStack {
                        Text("Welcome to\nWatchCord!")
                            .multilineTextAlignment(.leading)
                            .font(.title3)
                        Spacer()
                        Image("WatchCord")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: WKInterfaceDevice.current().screenBounds.width / 4)
                            .clipShape(Circle())
                    }
                    .padding()
                    Spacer()
                    Text("Oops! We couldn't find any login details to start! Please open the app on your phone to log in!")
                        .font(.footnote)
                        .padding()
                    Spacer()
                }
            }
        }
    }
}

struct appPreviews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}




extension Color {
    init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0)
   }

    init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

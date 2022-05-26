//
//  WatchCordApp.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 15/05/2022.
//

import SwiftUI
import WatchConnectivity

@main
struct WatchCordApp: App {
    
    @ObservedObject var data = DataTransportModel.shared
    
    @State var token = AccordCoreVars.token
    @State var popup: Bool = false
    
    @State var override = false
    
    @State var issueMessage = "Oops! We couldn't find any login details to start! Please open the app on your phone to log in!"
    
    var body: some Scene {
        WindowGroup {
            if self.token == "" && override == false {
                // is not logged in
                LoginView(issueMessage: issueMessage, override: $override)
                    .onReceive(data.data.publisher) { _ in
                        /// We received data from teh phone go like do something with it and pray its a token
                        let token = data.data
                        if token == "" {
                            issueMessage = "Oh no! Your credentials seem to be incorrectly stored on your phone! Please log out and in again!"
                        } else {
                            issueMessage = "Great! The sync worked! Relaunching..."
                        }
                        UserDefaults.standard.set(token, forKey: keychainItemName)
                        AccordCoreVars.token = token
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                self.override = true
                            }
                        }
                    }
                    .onAppear {
                        UserDefaults.standard.set("egg", forKey: "egg")
                        print(NSHomeDirectory())
                    }
            } else {
                ContentView(token: $token)
                    .navigationBarHidden(true)
                    .onReceive(data.data.publisher) { _ in
                        /// We received data from teh phone go like do something with it and pray its a token
                        let token = data.data
                        if token == "" {
                            issueMessage = "Oh no! Your credentials seem to be incorrectly stored on your phone! Please log out and in again!"
                        } else {
                            issueMessage = "Great! The sync worked! Relaunching..."
                        }
                        UserDefaults.standard.set(token, forKey: keychainItemName)
                        AccordCoreVars.token = token
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                self.override = true
                            }
                        }
                    }
            }
        }
    }
}

fileprivate struct LoginView: View {
    
    @ObservedObject var data = DataTransportModel.shared
    
    @State var issueMessage: String
    
    @Binding var override: Bool

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
                    Text(issueMessage)
                        .font(.footnote)
                        .padding()
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

class DataTransportModel : NSObject, WCSessionDelegate, ObservableObject {
    static let shared = DataTransportModel()
    let session = WCSession.default
    
    @Published var data : String = ""
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let _ = error { return }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        guard let incoming = userInfo["data"] as? String else { return }
        DispatchQueue.main.async {
            self.data = incoming // data was sent over
        }
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

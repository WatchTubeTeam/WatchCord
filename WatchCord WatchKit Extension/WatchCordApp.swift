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
    
    @State var token = AccordCoreVars.token
    @State var loaded: Bool = false
    @State var popup: Bool = false

    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if self.token == "e" {
                    // is not logged in
                    LoginView()
                } else {
                    SidebarView()
                }
            }
        }
    }
}

fileprivate struct LoginView: View {
    
    @ObservedObject var data = DataTransportModel.shared
    
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
        .onReceive(data.data.publisher) { _ in
            /// We received data from teh phone go like do something with it and pray its a token
            let data = data.data
            let tokenstring = String(data: data, encoding: .utf8)
        }
    }
}

class DataTransportModel : NSObject, WCSessionDelegate, ObservableObject {
    static let shared = DataTransportModel()
    let session = WCSession.default
    
    @Published var data : Data = Data()
    
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
        guard let incoming = userInfo["data"] as? Data else { return }
        DispatchQueue.main.async {
            self.data = incoming // data was sent over
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

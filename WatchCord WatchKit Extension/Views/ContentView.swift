//
//  ContentView.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 20/05/2022.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ContentView: View {
    
    @State var wsCancellable = Set<AnyCancellable>()
    @State var loaded: Bool = false
    @State var userData: GatewayD! = nil

    enum LoadErrors: Error {
        case alreadyLoaded
        case offline
    }
    
    var body: some View {
        if !loaded {
            
            // MARK: - Load user data
            
            LoadingView()
                .onAppear {
                    concurrentQueue.async {
                        
                        DispatchQueue.global().async {
                            NetworkCore.shared = NetworkCore()
                        }
                        DispatchQueue.global(qos: .background).async {
                            Regex.precompute()
                        }
                        
                        guard AccordCoreVars.token != "" else { return }
                        do {
                            guard userData == nil else {
                                loaded = true
                                return
                            }
                            guard wss == nil else {
                                throw LoadErrors.alreadyLoaded
                            }
                            guard NetworkCore.shared.connected else {
                                throw LoadErrors.offline
                            }
                            print("hiiiii")
                            let new = try Gateway(
                                url: Gateway.gatewayURL,
                                compress: UserDefaults.standard.value(forKey: "CompressGateway") as? Bool ?? true
                            )
                            new.ready()
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished: break
                                    case let .failure(error):
                                        failedToConnect(error)
                                    }
                                }) { d in
                                    AccordCoreVars.user = d.user
                                    user_id = d.user.id
                                    if let pfp = d.user.avatar {
                                        avatar = URL(string: cdnURL + "/avatars/\(d.user.id)/\(pfp).png?size=80")
                                    }
                                    let datastuffs = d
                                    DispatchQueue.main.async {
                                        self.userData = datastuffs
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            loaded = true
                                        }
                                    }
                                }
                                .store(in: &wsCancellable)
                            wss = new
                        } catch {
                            failedToConnect(error)
                        }
                    }
                }
        } else {
            
            // MARK: - Finished or failed to load user data
            
            VStack {
                Text(userData.user.username)
                WebImage(url: avatar)
            }
        }
    }
    
    func failedToConnect(_ error: Error) {
        print(error)
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("socketOut.json")
        do {
            let data = try Data(contentsOf: path)
            let structure = try JSONDecoder().decode(GatewayStructure.self, from: data)
            DispatchQueue.main.async {
                self.userData = structure.d
                AccordCoreVars.user = structure.d.user
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    loaded = true
                }
            }
        } catch {
            print(error)
        }
    }
}

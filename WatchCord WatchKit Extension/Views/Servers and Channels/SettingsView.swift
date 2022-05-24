//
//  SettingsView.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 23/05/2022.
//

import SwiftUI

struct SettingsView: View {
    var user: User
    var settings: DiscordSettings
    var body: some View {
        Text("Heya, \(user.username)!")
        NavigationLink {
            Text(user.discriminator)
        } label: {
            Text("Splash Settings")
        }

    }
}

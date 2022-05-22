//
//  WelcomeView.swift
//  WatchCord WatchKit Extension
//
//  Created by Lakhan Lothiyi on 22/05/2022.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        HStack {
            Text("Welcome to \nWatchCord!")
                .font(.callout)
                .minimumScaleFactor(0.1)
                .lineLimit(2)
            Spacer()
        }
        HStack {
            Text("Open a server to get started")
                .lineLimit(2)
                .font(.footnote)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.1)
            Spacer()
        }
        Spacer()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

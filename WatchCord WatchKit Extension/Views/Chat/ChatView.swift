//
//  ChatView.swift
//  WatchCord WatchKit Extension
//
//  Created by Lakhan Lothiyi on 22/05/2022.
//

import Foundation
import SwiftUI

struct ChatView: View {
    
    @Binding var currentGuild: String
    @Binding var currentChannel: String

    var body: some View {
        VStack {
            Text(currentGuild)
            Text(currentChannel)
        }
    }
}

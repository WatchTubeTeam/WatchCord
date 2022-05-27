//
//  msgCell.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 26/05/2022.
//

import SwiftUI

struct msgCell: View {
    var msg: Message
    var body: some View {
        VStack {
            Text(msg.author!.username)
            Text(msg.content)
        }
    }
}

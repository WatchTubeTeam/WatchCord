//
//  PlaceholderPfpUrlGen.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 21/05/2022.
//

import Foundation

struct placeholders {
    static func avatar() -> String {
        let num = Int.random(in: 0...5)
        return "\(cdnURL)/embed/avatars/\(num).png"
    }
}

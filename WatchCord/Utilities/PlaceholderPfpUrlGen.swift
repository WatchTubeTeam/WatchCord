//
//  PlaceholderPfpUrlGen.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 21/05/2022.
//

import Foundation

struct placeholders {
    static func avatar(_ tagstr: String) -> String {
        let tag = Int(tagstr) ?? 0
        let image = tag % 5
        return "\(cdnURL)/embed/avatars/\(image).png"
    }
}

//
//  SampleDataProvision.swift
//  WatchCord WatchKit Extension
//
//  Created by llsc12 on 15/05/2022.
//

import Foundation

// fake api for testing

struct Discord {
    static var testServerData = [
        dServer(name: "Aquacious", image: "https://cdn.discordapp.com/icons/834810916692033536/403ffe2df286e8e49bd94bbe608f268b.png", id: "834810916692033536", categories: [
            dCategory(name: "News", channels: [
                dChannel(name: "announcements", type: .announcement, id: "834811241100607500"),
                dChannel(name: "github", type: .text, id: "834811264513081364")
            ]),
            dCategory(name: "General", channels: [
                dChannel(name: "general", type: .text, id: "834810916692033539"),
                dChannel(name: "gm-gn", type: .text, id: "839293490138972160"),
                dChannel(name: "General", type: .voice, id: "834810916692033540"),
                dChannel(name: "podium", type: .stage, id: "880809820561760337")
            ])
        ]),
        dServer(name: "WatchTube", image: "https://cdn.discordapp.com/icons/921858903493455892/2414e4fc883498005541342f93e19b21.png", id: "921858903493455892", categories: [
            dCategory(name: "Information", channels: [
                dChannel(name: "announcements", type: .announcement, id: "921865726527148103"),
                dChannel(name: "github-feed", type: .text, id: "921865756185079819")
            ]),
            dCategory(name: "Text Channels", channels: [
                dChannel(name: "general", type: .text, id: "921858903493455896"),
                dChannel(name: "development", type: .text, id: "921859951268364318"),
                dChannel(name: "support", type: .text, id: "921859966585933845")
            ]),
            dCategory(name: "Voice Channels", channels: [
                dChannel(name: "Dev Work", type: .voice, id: "932318535659712515")
            ])
        ]),
        dServer(name: "MiniSeries Apps Official", image: "https://cdn.discordapp.com/icons/761691351682121778/a_41f042d2f7d6adedae1a725c5e247e32.gif", id: "940712352330973256", categories: [
            dCategory(name: "Important", channels: [
                dChannel(name: "rules", type: .text, id: "761691658509090826"),
                dChannel(name: "announcements", type: .announcement, id: "801528738545401877")
            ]),
            dCategory(name: "General", channels: [
                dChannel(name: "general-chat", type: .text, id: "789198566353797180"),
                dChannel(name: "memes", type: .text, id: "788899895583047681")
            ])
        ]),
        dServer(name: "Aquacious", image: "https://cdn.discordapp.com/icons/834810916692033536/403ffe2df286e8e49bd94bbe608f268b.png", id: "834810916692033536", categories: [
            dCategory(name: "News", channels: [
                dChannel(name: "announcements", type: .announcement, id: "834811241100607500"),
                dChannel(name: "github", type: .text, id: "834811264513081364")
            ]),
            dCategory(name: "General", channels: [
                dChannel(name: "general", type: .text, id: "834810916692033539"),
                dChannel(name: "gm-gn", type: .text, id: "839293490138972160"),
                dChannel(name: "General", type: .voice, id: "834810916692033540"),
                dChannel(name: "podium", type: .stage, id: "880809820561760337")
            ])
        ]),
        dServer(name: "WatchTube", image: "https://cdn.discordapp.com/icons/921858903493455892/2414e4fc883498005541342f93e19b21.png", id: "921858903493455892", categories: [
            dCategory(name: "Information", channels: [
                dChannel(name: "announcements", type: .announcement, id: "921865726527148103"),
                dChannel(name: "github-feed", type: .text, id: "921865756185079819")
            ]),
            dCategory(name: "Text Channels", channels: [
                dChannel(name: "general", type: .text, id: "921858903493455896"),
                dChannel(name: "development", type: .text, id: "921859951268364318"),
                dChannel(name: "support", type: .text, id: "921859966585933845")
            ]),
            dCategory(name: "Voice Channels", channels: [
                dChannel(name: "Dev Work", type: .voice, id: "932318535659712515")
            ])
        ]),
        dServer(name: "MiniSeries Apps Official", image: "https://cdn.discordapp.com/icons/761691351682121778/a_41f042d2f7d6adedae1a725c5e247e32.gif", id: "940712352330973256", categories: [
            dCategory(name: "Important", channels: [
                dChannel(name: "rules", type: .text, id: "761691658509090826"),
                dChannel(name: "announcements", type: .announcement, id: "801528738545401877")
            ]),
            dCategory(name: "General", channels: [
                dChannel(name: "general-chat", type: .text, id: "789198566353797180"),
                dChannel(name: "memes", type: .text, id: "788899895583047681")
            ])
        ]),
        dServer(name: "Aquacious", image: "https://cdn.discordapp.com/icons/834810916692033536/403ffe2df286e8e49bd94bbe608f268b.png", id: "834810916692033536", categories: [
            dCategory(name: "News", channels: [
                dChannel(name: "announcements", type: .announcement, id: "834811241100607500"),
                dChannel(name: "github", type: .text, id: "834811264513081364")
            ]),
            dCategory(name: "General", channels: [
                dChannel(name: "general", type: .text, id: "834810916692033539"),
                dChannel(name: "gm-gn", type: .text, id: "839293490138972160"),
                dChannel(name: "General", type: .voice, id: "834810916692033540"),
                dChannel(name: "podium", type: .stage, id: "880809820561760337")
            ])
        ]),
        dServer(name: "WatchTube", image: "https://cdn.discordapp.com/icons/921858903493455892/2414e4fc883498005541342f93e19b21.png", id: "921858903493455892", categories: [
            dCategory(name: "Information", channels: [
                dChannel(name: "announcements", type: .announcement, id: "921865726527148103"),
                dChannel(name: "github-feed", type: .text, id: "921865756185079819")
            ]),
            dCategory(name: "Text Channels", channels: [
                dChannel(name: "general", type: .text, id: "921858903493455896"),
                dChannel(name: "development", type: .text, id: "921859951268364318"),
                dChannel(name: "support", type: .text, id: "921859966585933845")
            ]),
            dCategory(name: "Voice Channels", channels: [
                dChannel(name: "Dev Work", type: .voice, id: "932318535659712515")
            ])
        ]),
        dServer(name: "MiniSeries Apps Official", image: "https://cdn.discordapp.com/icons/761691351682121778/a_41f042d2f7d6adedae1a725c5e247e32.gif", id: "940712352330973256", categories: [
            dCategory(name: "Important", channels: [
                dChannel(name: "rules", type: .text, id: "761691658509090826"),
                dChannel(name: "announcements", type: .announcement, id: "801528738545401877")
            ]),
            dCategory(name: "General", channels: [
                dChannel(name: "general-chat", type: .text, id: "789198566353797180"),
                dChannel(name: "memes", type: .text, id: "788899895583047681")
            ])
        ])
    ]
    static var testUserData = [
        dUser(username: "clum", tag: 1965, id: "549604509614211073", thumb: "https://cdn.discordapp.com/avatars/549604509614211073/06bc15d223fca424199fa0a0649844c9.png?size=1024"),
        dUser(username: "llsc12", tag: 1902, id: "381538809180848128", thumb: "https://cdn.discordapp.com/avatars/381538809180848128/b99386d1217673d7a9a25aaeca55c6f0.png")
    ]
    static func myServers() -> [dServer] {
        return testServerData
    }
    static func server(_ id: String) -> dServer! {
        let results = testServerData.filter {$0.id == id}
        return results.first
    }
}

struct dServer {
    var name: String
    var image: String
    var id: String
    var categories: [dCategory]
}

struct dCategory {
    var name: String
    var channels: [dChannel]
}

struct dChannel {
    var name: String
    var type: dChannelType
    var id: String
}

struct dUser {
    var username: String
    var tag: Int
    var id: String
    var thumb: String
}

enum dChannelType {
    case text
    case voice
    case stage
    case announcement
}

struct dChatMessage {
    var user: String
    var content: String
    var dateString: String
    var reactions: [dReaction]
}

struct dReaction {
    var id: String
    var isAnimated: Bool
    var count: Int
    var userReacted: Bool
}

//
//  User.swift
//  User
//
//  Created by Evelyn on 2021-08-16.
//

import Foundation

final class User: Codable, Identifiable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    var id: String
    var username: String
    var discriminator: String
    var avatar: String?
    var bot: Bool?
    var system: Bool?
    var mfa_enabled: Bool?
    var locale: String?
    var verified: Bool?
    var email: String?
    var flags: Int?
    var premium_type: NitroTypes?
    var public_flags: Int?
    var bio: String?
    var nick: String?
    var roleColor: String?
    var banner: String?
    var banner_color: String?

    func isMe() -> Bool { user_id == id }

    // MARK: - Relationships

    func addFriend(_: String, _: String) {
//        let headers = Headers(
//            userAgent: discordUserAgent,
//            token: AccordCoreVars.token,
//            type: .PUT,
//            discordHeaders: true,
//            referer: "https://discord.com/channels/\(guild)/\(channel)"
//        )
//         Request.fetch(url: URL(string: "\(rootURL)/users/@me/relationships/\(id)"), headers: headers)
    }

    func removeFriend(_: String, _: String) {
//        let headers = Headers(
//            userAgent: discordUserAgent,
//            token: AccordCoreVars.token,
//            type: .DELETE,
//            discordHeaders: true,
//            referer: "https://discord.com/channels/\(guild)/\(channel)"
//        )
//         Request.fetch(url: URL(string: "\(rootURL)/users/@me/relationships/\(id)"), headers: headers)
    }

    func block(_: String, _: String) {
//        let headers = Headers(
//            userAgent: discordUserAgent,
//            token: AccordCoreVars.token,
//            bodyObject: ["type":2],
//            type: .PUT,
//            discordHeaders: true,
//            referer: "https://discord.com/channels/\(guild)/\(channel)"
//        )
//         Request.fetch(url: URL(string: "\(rootURL)/users/@me/relationships/\(id)"), headers: headers)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum NitroTypes: Int, Codable {
    case none = 0
    case classic = 1
    case nitro = 2
}

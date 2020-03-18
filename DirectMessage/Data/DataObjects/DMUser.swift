//
//  DMUser.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/8.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

class DMUser: Decodable {
    
    enum UserType: String {
        case user = "User"
        case organization = "Organization"
        case other
    }
        
    var username: String
    var id: UInt
    var nodeId: String
    var avatarUrl: URL?
    var gravatarId: String
    var url: URL?
    var htmlUrl: URL?
    var type: UserType
    var siteAdmin: Bool
    
    var handleName: String {
        return "@\(self.username)"
    }

    enum CodingKeys: String, CodingKey {
        case id, url, type
        case username = "login"
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case htmlUrl = "html_url"
        case siteAdmin = "site_admin"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        id = try container.decode(UInt.self, forKey: .id)
        nodeId = try container.decode(String.self, forKey: .nodeId)
        avatarUrl = try container.decodeIfPresent(URL.self, forKey: .avatarUrl)
        gravatarId = try container.decode(String.self, forKey: .gravatarId)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        htmlUrl = try container.decodeIfPresent(URL.self, forKey: .htmlUrl)
        let typeString = try container.decode(String.self, forKey: .type)
        type = DMUser.transformTypeFromJSON(typeString)
        siteAdmin = try container.decode(Bool.self, forKey: .siteAdmin)
    }
    
}

extension DMUser {
    
    static func transformTypeFromJSON(_ value: Any?) -> UserType {
        guard let string = value as? String else { return .other }
        switch string {
        case "User":
            return .user
        case "Organization":
            return .organization
        default:
            return .other
        }
    }

}

//
//  Follower.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 21.06.22.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
}

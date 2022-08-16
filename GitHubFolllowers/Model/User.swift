//
//  User.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 21.06.22.
//

import Foundation

struct User: Codable {
    let login: String
    var name: String?
    let avatarUrl: String
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date
}

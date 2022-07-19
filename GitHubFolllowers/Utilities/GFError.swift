//
//  GFError.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 12.07.22.
//

import Foundation

enum GFError: String, Error {
    case invalidUserName = "this username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server was invalid. please try again"
}

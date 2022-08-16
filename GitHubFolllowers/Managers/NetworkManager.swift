//
//  NetworkManager.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 23.06.22.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    let baseURL = "https://api.github.com/users/"
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
//    func getFollowers(for username: String, page: Int, completed: @escaping(Result<[Follower], GFError>) -> Void) {
//        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
//
//        guard let url = URL(string: endpoint) else {
//            completed(.failure(.invalidUserName))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                completed(.failure(.unableToComplete))
//                print(error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let followers = try decoder.decode([Follower].self, from: data)
//                completed(.success(followers))
//            } catch {
//                completed(.failure(.invalidData))
//            }
//        }
//        task.resume()
//    }
    
    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUserName
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        do {
            return try decoder.decode([Follower].self, from: data)
            
        } catch {
            throw GFError.invalidData
        }
    }

//    func getUsers (for username: String, completed: @escaping(Result<User, GFError>) -> Void) {
//        let endpoint = baseURL + "\(username)"
//
//        guard let url = URL(string: endpoint) else {
//            completed(.failure(.invalidUserName))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                completed(.failure(.unableToComplete))
//                print(error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                decoder.dateDecodingStrategy = .iso8601
//                let user = try decoder.decode(User.self, from: data)
//                completed(.success(user))
//            } catch {
//                completed(.failure(.invalidData))
//            }
//        }
//        task.resume()
//    }
    
    func getUsers (for username: String) async throws -> User {
        let endpoint = baseURL + "\(username)"
  
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUserName
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
//    func downloadImage(from urlString: String, completed: @escaping ((UIImage)?) -> Void) {
//        let convertString = NSString(string: urlString)
//
//        if let image = cache.object(forKey: convertString) {
//            completed(image)
//            return
//        }
//
//        guard let url = URL(string: urlString) else {
//            completed(nil)
//            return }
//
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, responce, error in
//
//            guard let self = self, error == nil,
//                let responce = responce as? HTTPURLResponse, responce.statusCode == 200,
//                let data = data,
//                let image = UIImage(data: data) else {
//                    completed(nil)
//                return
//                }
//
//            self.cache.setObject(image, forKey: convertString)
//            completed(image)
//
//        }
//        task.resume()
//    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        
        let convertString = NSString(string: urlString)
        
        if let image = cache.object(forKey: convertString) {
            return image
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: convertString)
            return image
        } catch {
            return nil
        }
    }
}

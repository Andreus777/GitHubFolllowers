//
//  GFAvatarImageView.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 30.06.22.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholderImage = Images.placeholder
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        image = placeholderImage
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadAvatarImage(fromURL url: String) {
        Task {
            image = await NetworkManager.shared.downloadImage(from: url)
        }
    }
}

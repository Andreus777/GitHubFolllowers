//
//  GFAvatarImageView.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 30.06.22.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholderImage = UIImage(named: "avatar-placeholder")
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
    
    func downloadImage(from urlString: String) {
        
        let convertString = NSString(string: urlString)
        
        if let image = cache.object(forKey: convertString) {
            self.image = image
            return
        }
            
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, responce, error in
            guard let self = self else {return}
            if error != nil {return}
            guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else {return}
            guard let data = data else {return}
            
            guard let image = UIImage(data: data) else {return}
            self.cache.setObject(image, forKey: convertString)
            DispatchQueue.main.async {
                self.image = image
            }

        }
        task.resume()
    }
}

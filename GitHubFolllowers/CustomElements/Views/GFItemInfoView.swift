//
//  GFItemInfoView.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 16.07.22.
//

import UIKit

class GFItemInfoView: UIView {
    
    enum ItemInfoType {
        case repos, gists, followers, following
    }
    
    let titleLabel = GFTitleLabel(fontSize: 14, testAligment: .left)
    let countLabel = GFTitleLabel(fontSize: 14, testAligment: .center)
    let symbolView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(titleLabel, countLabel, symbolView)
        
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        symbolView.contentMode = .scaleAspectFill
        symbolView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolView.heightAnchor.constraint(equalToConstant: 20),
            symbolView.widthAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
        
            countLabel.topAnchor.constraint(equalTo: symbolView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
        
        func set(itemInfoType: ItemInfoType, count: Int) {
            switch itemInfoType {
            case .repos:
                titleLabel.text = "Public repos"
                symbolView.image = GFSymbols.repos
            case .gists:
                titleLabel.text = "Public gists"
                symbolView.image = GFSymbols.gists
            case .followers:
                titleLabel.text = "Followers"
                symbolView.image = GFSymbols.followers
            case .following:
                titleLabel.text = "Following"
                symbolView.image = GFSymbols.following
            }
            
            countLabel.text = String(count)
        }
}

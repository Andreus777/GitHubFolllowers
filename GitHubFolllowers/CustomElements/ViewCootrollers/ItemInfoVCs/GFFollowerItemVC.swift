//
//  GFFollowerItemVC.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 19.07.22.
//

import UIKit

protocol GFFollowersItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFitemInfoVC {
    
    weak var delegate: GFFollowersItemVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    init(user: User, delegate: GFFollowersItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureItems() {
        itemInfoOne.set(itemInfoType: .followers, count: user.followers)
        itemInfoTwo.set(itemInfoType: .following, count: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Git Followers")
    }
    
    override func actionButtonTapped() {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 🧐.", buttonTitle: "Ok")
            return
        }
        delegate?.didTapGetFollowers(for: user)
        dismiss(animated: true)
    }
}

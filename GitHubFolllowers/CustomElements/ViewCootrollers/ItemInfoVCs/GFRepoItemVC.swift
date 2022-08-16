//
//  GFRepoItemVC.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 19.07.22.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFitemInfoVC {
    
    weak var delegate: GFRepoItemVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureItems() {
        itemInfoOne.set(itemInfoType: .repos, count: user.publicRepos)
        itemInfoTwo.set(itemInfoType: .gists, count: user.publicGists)
        actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGitHubProfile(for: user)
    }
}

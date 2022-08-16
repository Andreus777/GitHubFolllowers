//
//  UserInfoVC.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 12.07.22.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    
    var username: String?
    weak var delegate: UserInfoVCDelegate?
    
    let headerView = UIView()
    let viewNumberOne = UIView()
    let viewNumberTwo = UIView()
    let dateLabel = GFBodyLabel(testAligment: .center)
    
    var itemViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDoneButton()
        congigureUI()
        getUserinfo()
    }
    
    func setupDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func getUserinfo() {
        NetworkManager.shared.getUsers(for: username!) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: User) {
        self.addChildVC(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.addChildVC(childVC: GFRepoItemVC(user: user, delegate: self), to: self.viewNumberOne)
        self.addChildVC(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.viewNumberTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertDateToString())"
    }
    
    func congigureUI() {
        
        itemViews = [headerView, viewNumberOne, viewNumberTwo, dateLabel]
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            viewNumberOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
           
            viewNumberOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            viewNumberTwo.topAnchor.constraint(equalTo: viewNumberOne.bottomAnchor, constant: padding),
          
            viewNumberTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: viewNumberTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func addChildVC(childVC: UIViewController, to container: UIView) {
        addChild(childVC)
        container.addSubview(childVC.view)
        childVC.view.frame = container.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoVC: GFRepoItemVCDelegate, GFFollowersItemVCDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else { presentGFAlertOnMainThread(title: "Invalid URL",
                                                                                    message: "The url attached to this user is invalid",
                                                                                    buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        delegate?.didRequestFollowers(for: user.login)
    }
}

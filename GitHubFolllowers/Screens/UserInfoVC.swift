//
//  UserInfoVC.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 12.07.22.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var username: String?
    
    let headerView = UIView()
    let viewNumberOne = UIView()
    let viewNumberTwo = UIView()
    
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
                    self.addChildVC(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func congigureUI() {
        
        itemViews = [headerView, viewNumberOne, viewNumberTwo]
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
        viewNumberOne.backgroundColor = .systemPink
        viewNumberTwo.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            viewNumberOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
           
            viewNumberOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            viewNumberTwo.topAnchor.constraint(equalTo: viewNumberOne.bottomAnchor, constant: padding),
          
            viewNumberTwo.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
    }
    
    func addChildVC(childVC: UIViewController, to container: UIView) {
        addChild(childVC)
        container.addSubview(childVC.view)
        childVC.view.frame = container.bounds
        childVC.didMove(toParent: self)
    }
}

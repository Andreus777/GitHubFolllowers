//
//  GFitemInfoVC.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 19.07.22.
//

import UIKit

class GFitemInfoVC: UIViewController {
    
    let stackView = UIStackView()
    let itemInfoOne = GFItemInfoView()
    let itemInfoTwo = GFItemInfoView()
    let actionButton = GFButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
    }
    
   private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
   private func layoutUI() {
       view.addSubview(stackView)
       view.addSubview(actionButton)
       
       stackView.translatesAutoresizingMaskIntoConstraints = false
       
       let padding: CGFloat = 20
    }
    
}

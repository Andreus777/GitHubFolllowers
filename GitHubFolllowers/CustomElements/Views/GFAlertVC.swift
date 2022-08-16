//
//  GFAlertVC.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 21.06.22.
//

import UIKit

class GFAlertVC: UIViewController {

    let containetView = GFAlertContainerView()
    let titleLabel = GFTitleLabel(fontSize: 20, testAligment: .center)
    let messageLanel = GFBodyLabel(testAligment: .center)
    let actionButton = GFButton(color: .systemPink, title: "Ok", systemImageName: "checkmark.circle")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init(alertTitle: String, message: String?, buttonTitle: String?) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubviews(containetView, titleLabel, actionButton, messageLanel)
        
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    func configureContainerView() {
        
        NSLayoutConstraint.activate([
            containetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containetView.widthAnchor.constraint(equalToConstant: 280),
            containetView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func configureTitleLabel() {
        titleLabel.text = alertTitle ?? ""
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containetView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containetView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containetView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
             
        ])
    }
    
    func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containetView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containetView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containetView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    func configureMessageLabel() {
        messageLanel.text = message ?? "Wrong reequest"
        messageLanel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLanel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLanel.leadingAnchor.constraint(equalTo: containetView.leadingAnchor, constant: padding),
            messageLanel.trailingAnchor.constraint(equalTo: containetView.trailingAnchor, constant: -padding),
            messageLanel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

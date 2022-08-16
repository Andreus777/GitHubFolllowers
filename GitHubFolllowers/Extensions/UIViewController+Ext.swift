//
//  UIViewController+Ext.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 21.06.22.
//

import SafariServices
import UIKit

extension UIViewController {
    
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    func presentDefaultError() {
        let alertVC = GFAlertVC(alertTitle: "Error", message: "Unable to complete", buttonTitle: "Ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}

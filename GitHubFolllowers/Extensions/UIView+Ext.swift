//
//  UIView+Ext.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 15.08.22.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

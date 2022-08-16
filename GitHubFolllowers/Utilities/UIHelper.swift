//
//  UIHelper.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 1.07.22.
//

import UIKit

enum UIHelper {
    
    static func createThreeColumnsFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumSpacing: CGFloat = 10
        let avalibleWidth = width - (padding * 2) - (minimumSpacing * 2)
        let itemWidth = avalibleWidth / 3
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        return flowLayout
    }
}

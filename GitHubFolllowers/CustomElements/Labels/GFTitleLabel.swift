//
//  GFTitleLabel.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 21.06.22.
//

import UIKit

class GFTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(fontSize: CGFloat, testAligment: NSTextAlignment) {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        self.textAlignment = testAligment
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}

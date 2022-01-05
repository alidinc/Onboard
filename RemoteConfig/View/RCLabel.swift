//
//  RCLabel.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import UIKit

class RCLabel: UILabel {

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat, weight: UIFont.Weight) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        textColor = UIColor.label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = NSLineBreakMode.byTruncatingTail
        numberOfLines = .zero
        translatesAutoresizingMaskIntoConstraints = false
    }
}

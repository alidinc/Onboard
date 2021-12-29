//
//  RCLabel.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import UIKit

class RCLabel: UILabel {

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
<<<<<<< HEAD
        setupView()
=======
        configure()
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(textAlignment: NSTextAlignment, fontSize: CGFloat, weight: UIFont.Weight) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
<<<<<<< HEAD
        setupView()
    }
    // MARK: - Methods
    private func setupView() {
        textColor = UIColor.label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = NSLineBreakMode.byTruncatingTail
        numberOfLines = .zero
=======
        configure()
    }
    // MARK: - Methods
    private func configure() {
        textColor                                 = UIColor.label
        adjustsFontSizeToFitWidth                 = true
        minimumScaleFactor                        = 0.9
        lineBreakMode                             = NSLineBreakMode.byTruncatingTail
        numberOfLines                             = .zero
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
        translatesAutoresizingMaskIntoConstraints = false
    }
}

//
//  RCImageView.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import UIKit

class RCImageView: UIImageView {

    // MARK: - Properties
    let placeholderImage = UIImage(named: "image")!

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    private func configure() {
        layer.cornerRadius                        = 22
        contentMode                               = .scaleAspectFill
        clipsToBounds                             = true
        image                                     = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}

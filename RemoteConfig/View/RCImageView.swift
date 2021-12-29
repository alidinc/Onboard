//
//  RCImageView.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import UIKit

class RCImageView: UIImageView {

    // MARK: - Properties
    private let placeholderImage = UIImage(named: "image")!

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
    // MARK: - Methods
<<<<<<< HEAD
    private func setupView() {
        layer.cornerRadius = 22
        contentMode = .scaleAspectFit
        clipsToBounds = true
        image = placeholderImage
=======
    private func configure() {
        layer.cornerRadius                        = 22
        contentMode                               = .scaleAspectFit
        clipsToBounds                             = true
        image                                     = placeholderImage
>>>>>>> cd08546e009a05615e4d0f1156c2ed05b9bc0d10
        translatesAutoresizingMaskIntoConstraints = false
    }
}

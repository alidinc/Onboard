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
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    private func setupView() {
        layer.cornerRadius = 22
        contentMode = .scaleAspectFit
        clipsToBounds = true
        layer.masksToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}

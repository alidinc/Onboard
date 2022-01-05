//
//  RCImageView.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import UIKit
import SnapKit

class RCImageView: UIImageView {

    #warning("Use this instead of implementing a new class")
    /*private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(named: "image")!
        imageView.layer.cornerRadius = 22
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.image = placeholderImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()*/
    
    // MARK: - Properties
    private let placeholderImage = UIImage(named: "image")!

    // MARK: - Lifecycle
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

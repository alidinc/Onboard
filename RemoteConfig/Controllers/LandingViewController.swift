//
//  LandingViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 21/12/2021.
//

import Foundation
import UIKit

class LandingViewController: UIViewController {

    // MARK: - Properties
    private let imageView = RCImageView(frame: .zero)
    private lazy var captureButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(configureImagePicker(for:)), for: .touchUpInside)
        button.setTitle("Capture Photo", for: .normal)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var pickFromLibraryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(configureImagePicker(for:)), for: .touchUpInside)
        button.setTitle("Pick From Library", for: .normal)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    // MARK: - Methods
    private func configureView() {
        view.backgroundColor = .lightGray
        view.addSubview(imageView)
        view.addSubview(captureButton)
        view.addSubview(pickFromLibraryButton)
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            captureButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            captureButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            pickFromLibraryButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            pickFromLibraryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
}

// MARK: - UIImagePickerController
extension LandingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @objc private func configureImagePicker(for sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        setImagePickerSource(imagePicker, for: sender)
        present(imagePicker, animated: true, completion: nil)
    }

    private func setImagePickerSource(_ imagePicker: UIImagePickerController, for sender: UIButton) {
        if sender.tag == 0 && UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType          = .camera
            imagePicker.showsCameraControls = true
        } else if sender.tag == 1 && UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType          = .photoLibrary
        } else {
            self.presentAlert(title: "Not available", message: "Please check your camera or photo library settings.", buttonTitle: "OK")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        self.dismiss(animated: true, completion: nil)
    }
}

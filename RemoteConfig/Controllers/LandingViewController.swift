//
//  LandingViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 21/12/2021.
//

import SevenAppsKit
import SnapKit
import UIKit

class LandingViewController: UIViewController {

    // MARK: - Properties
    private lazy var captureButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        button.setTitle(R.string.localizable.capturePhoto(), for: .normal)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var pickFromLibraryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)
        button.setTitle(R.string.localizable.pickFromLibrary(), for: .normal)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let imageView = RCImageView(frame: .zero)
    private let imagePicker = UIImagePickerController()
    private let isCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front) || UIImagePickerController.isCameraDeviceAvailable(.rear)


    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImagePicker()
    }
    // MARK: - Methods
    private func setupView() {
        view.backgroundColor = .lightGray
        view.addSubview(imageView)
        view.addSubview(captureButton)
        view.addSubview(pickFromLibraryButton)
        let padding: CGFloat = 20

        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        captureButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(padding)
            make.leading.equalToSuperview().offset(padding)
        }
        pickFromLibraryButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
    }
}

// MARK: - UIImagePickerController
extension LandingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private func setupImagePicker() {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }

    @objc private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        } else {
            SAK.UI.AlertControllerBuilder(message: "No access to photo library",
                                          actions: [.okay], style: .alert)
                .present(in: self, completion: nil)
        }
    }

    @objc private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.showsCameraControls = true
            present(imagePicker, animated: true)
        } else {
            SAK.UI.AlertControllerBuilder(message: "No camera device found",
                                          actions: [.okay], style: .alert)
                .present(in: self, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
            
            //viewModel.detectSegmentationMask(on: editedImage, for: imageView)
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
            //viewModel.detectSegmentationMask(on: originalImage, for: imageView)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

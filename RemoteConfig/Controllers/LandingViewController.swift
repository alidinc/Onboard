//
//  LandingViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 21/12/2021.
//

import SevenAppsKit
import SnapKit
import UIKit
import MLKitSegmentationSelfie

class LandingViewController: UIViewController {

    // MARK: - Properties
    private lazy var captureButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        button.setTitle(R.string.localizable.capturePhoto(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var pickFromLibraryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)
        button.setTitle(R.string.localizable.pickFromLibrary(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let imagePicker = UIImagePickerController()
    private let isCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front) ||
    UIImagePickerController.isCameraDeviceAvailable(.rear)
    private let imageView = RCImageView(frame: .zero)
    private var segmenter: Segmenter!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImagePicker()
        setupSegmenter()
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
    private func setupSegmenter() {
        let options = SelfieSegmenterOptions()
        options.segmenterMode = .singleImage
        options.shouldEnableRawSizeMask = false
        segmenter = Segmenter.segmenter(options: options)
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
            FaceDetector.shared.faceDetectRequest(for: editedImage, in: self)
            imageView.image = editedImage
            setBackgroundRemover(for: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            FaceDetector.shared.faceDetectRequest(for: originalImage, in: self)
            imageView.image = originalImage
            setBackgroundRemover(for: originalImage)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension LandingViewController: SelfieRemovalDelegate, ObjectRemovalDelegate {
    private func setBackgroundRemover(for image: UIImage) {
        if let hasDetectedFace = FaceDetector.shared.hasDetectedFace {
            if hasDetectedFace {
                self.detectSegmentationMask(on: image, for: self.imageView, with: self.segmenter)
            } else {
                self.removeBackgroundFromObjects(from: image, for: self.imageView)
            }
        }
    }
}

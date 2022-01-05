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
    private lazy var segmenter: Segmenter = {
        let options = SelfieSegmenterOptions()
        options.segmenterMode = .singleImage
        options.shouldEnableRawSizeMask = false
        let segmenter = Segmenter.segmenter(options: options)
        return segmenter
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImagePicker()
        #warning("Revert if not working")
        // setupSegmenter()
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
    
    /*private func setupSegmenter() {
        let options = SelfieSegmenterOptions()
        options.segmenterMode = .singleImage
        options.shouldEnableRawSizeMask = false
        segmenter = Segmenter.segmenter(options: options)
    }*/
}

// MARK: - UINavigationControllerDelegate & UIImagePickerControllerDelegate
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
            setBackgroundRemover(for: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            setBackgroundRemover(for: originalImage)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SelfieRemovalDelegate, ObjectRemovalDelegate
extension LandingViewController: SelfieRemovalDelegate, ObjectRemovalDelegate {
    #warning("Move to main class definition")
    #warning("a better naming, maybe removeBackground from image")
    private func setBackgroundRemover(for image: UIImage) {
        FaceDetector().faceDetectRequest(for: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let faceDetection):
                let confidence = String(format: "%.2f", faceDetection.confidence * 100)
                self.presentAlertWithHandlers(title: "Face detected",
                                              message: "There's a face in this image with a confidence of %\(confidence) MLKitSegmentationSelfie will be applied.",
                                              buttonTitle: "OK") { _ in
                    self.removeBackgroundFromSelfieWithMLKit(on: image, with: self.segmenter) { result in
                        DispatchQueue.main.async {
                            if let image = result {
                                self.imageView.image = image
                            }
                        }
                    }
                } cancelHandler: { _ in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            case .failure(let error):
                self.presentAlertWithHandlers(title: "No face detected",
                                              message: error.rawValue,
                                              buttonTitle: "OK") { _ in
                    self.removeBackgroundFromObjectsWithCoreML(from: image) { imageOutput in
                        DispatchQueue.main.async {
                            self.imageView.image = imageOutput?.maskInputImage(from: image)
                        }
                    }
                } cancelHandler: { _ in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}

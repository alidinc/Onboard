//
//  LandingViewController.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 21/12/2021.
//

import Foundation
import MLKit
import MLKitSegmentationSelfie
import UIKit

class LandingViewController: UIViewController {

    // MARK: - Properties
    private let imageView = RCImageView(frame: .zero)
    private lazy var captureButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(configureImagePicker(for:)), for: .touchUpInside)
        button.setTitle(R.string.localizable.capturePhoto(), for: .normal)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var pickFromLibraryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(configureImagePicker(for:)), for: .touchUpInside)
        button.setTitle(R.string.localizable.pickFromLibrary(), for: .normal)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let isCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front) || UIImagePickerController.isCameraDeviceAvailable(.rear)
    private var mask: SegmentationMask!
    private var segmenter: Segmenter!

    // MARK: - Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupSegmenter()
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

    private func setupSegmenter() {
        let options = SelfieSegmenterOptions()
        options.segmenterMode = .singleImage
        options.shouldEnableRawSizeMask = false
        segmenter = Segmenter.segmenter(options: options)
    }

    func detectSegmentationMask(image: UIImage?) {
        guard let image = image else { return }

        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation

        guard let segmenter = self.segmenter else { return }

        weak var weakSelf = self
        segmenter.process(visionImage) { mask, error in
            guard weakSelf != nil, error == nil, let mask = mask else { return }

            guard let imageBuffer = self.createImageBuffer(from: image) else { return }

            self.applySegmentationMask(
                mask: mask, to: imageBuffer,
                backgroundColor: UIColor.purple.withAlphaComponent(0.5),
                foregroundColor: nil)
            let maskedImage = self.createUIImage(from: imageBuffer, orientation: .up)
            self.imageView.image = maskedImage
        }
    }

    private func createUIImage(from imageBuffer: CVImageBuffer, orientation: UIImage.Orientation) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)
    }

    private func createImageBuffer(from image: UIImage) -> CVImageBuffer? {
        guard let cgImage = image.cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height

        var buffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, nil, &buffer)
        guard let imageBuffer = buffer else { return nil }

        let flags = CVPixelBufferLockFlags(rawValue: 0)
        CVPixelBufferLockBaseAddress(imageBuffer, flags)

        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let context = CGContext(
          data: baseAddress, width: width, height: height, bitsPerComponent: 8,
          bytesPerRow: bytesPerRow, space: colorSpace,
          bitmapInfo: (CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue))

        if let context = context {
          let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
          context.draw(cgImage, in: rect)
          CVPixelBufferUnlockBaseAddress(imageBuffer, flags)
          return imageBuffer
        } else {
          CVPixelBufferUnlockBaseAddress(imageBuffer, flags)
          return nil
        }
      }

    private func applySegmentationMask(mask: SegmentationMask, to imageBuffer: CVImageBuffer, backgroundColor: UIColor?, foregroundColor: UIColor?) {
        let width = CVPixelBufferGetWidth(mask.buffer)
        let height = CVPixelBufferGetHeight(mask.buffer)

        if backgroundColor == nil && foregroundColor == nil { return }

        let writeFlags = CVPixelBufferLockFlags(rawValue: 0)
        CVPixelBufferLockBaseAddress(imageBuffer, writeFlags)
        CVPixelBufferLockBaseAddress(mask.buffer, CVPixelBufferLockFlags.readOnly)

        let maskBytesPerRow = CVPixelBufferGetBytesPerRow(mask.buffer)
        var maskAddress = CVPixelBufferGetBaseAddress(mask.buffer)!.bindMemory(to: Float32.self, capacity: maskBytesPerRow * height)

        let imageBytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        var imageAddress = CVPixelBufferGetBaseAddress(imageBuffer)!.bindMemory(to: UInt8.self, capacity: imageBytesPerRow * height)

        var redFG: CGFloat = 0.0
        var greenFG: CGFloat = 0.0
        var blueFG: CGFloat = 0.0
        var alphaFG: CGFloat = 0.0
        var redBG: CGFloat = 0.0
        var greenBG: CGFloat = 0.0
        var blueBG: CGFloat = 0.0
        var alphaBG: CGFloat = 0.0

        let backgroundColor = backgroundColor != nil ? backgroundColor : .clear
        let foregroundColor = foregroundColor != nil ? foregroundColor : .clear
        backgroundColor!.getRed(&redBG, green: &greenBG, blue: &blueBG, alpha: &alphaBG)
        foregroundColor!.getRed(&redFG, green: &greenFG, blue: &blueFG, alpha: &alphaFG)

        for _ in 0...(height - 1) {
            for col in 0...(width - 1) {
                let pixelOffset = col * 4
                let blueOffset = pixelOffset
                let greenOffset = pixelOffset + 1
                let redOffset = pixelOffset + 2
                let alphaOffset = pixelOffset + 3

                let maskValue: CGFloat = CGFloat(maskAddress[col])
                let backgroundRegionRatio: CGFloat = 1.0 - maskValue
                let foregroundRegionRatio = maskValue

                let originalPixelRed: CGFloat =
                CGFloat(imageAddress[redOffset]) / 255
                let originalPixelGreen: CGFloat =
                CGFloat(imageAddress[greenOffset]) / 255
                let originalPixelBlue: CGFloat =
                CGFloat(imageAddress[blueOffset]) / 255
                let originalPixelAlpha: CGFloat =
                CGFloat(imageAddress[alphaOffset]) / 255

                let redOverlay = redBG * backgroundRegionRatio + redFG * foregroundRegionRatio
                let greenOverlay = greenBG * backgroundRegionRatio + greenFG * foregroundRegionRatio
                let blueOverlay = blueBG * backgroundRegionRatio + blueFG * foregroundRegionRatio
                let alphaOverlay = alphaBG * backgroundRegionRatio + alphaFG * foregroundRegionRatio

                // Calculate composite color component values.
                // Derived from https://en.wikipedia.org/wiki/Alpha_compositing#Alpha_blending
                let compositeAlpha: CGFloat = ((1.0 - alphaOverlay) * originalPixelAlpha) + alphaOverlay
                var compositeRed: CGFloat = 0.0
                var compositeGreen: CGFloat = 0.0
                var compositeBlue: CGFloat = 0.0
                // Only perform rgb blending calculations if the output alpha is > 0. A zero-value alpha
                // means none of the color channels actually matter, and would introduce division by 0.
                if abs(compositeAlpha) > CGFloat(Float.ulpOfOne) {
                    compositeRed =
                    (((1.0 - alphaOverlay) * originalPixelAlpha * originalPixelRed)
                     + (alphaOverlay * redOverlay)) / compositeAlpha
                    compositeGreen =
                    (((1.0 - alphaOverlay) * originalPixelAlpha * originalPixelGreen)
                     + (alphaOverlay * greenOverlay)) / compositeAlpha
                    compositeBlue =
                    (((1.0 - alphaOverlay) * originalPixelAlpha * originalPixelBlue)
                     + (alphaOverlay * blueOverlay)) / compositeAlpha
                }

                imageAddress[redOffset] = UInt8(compositeRed * 255)
                imageAddress[greenOffset] = UInt8(compositeGreen * 255)
                imageAddress[blueOffset] = UInt8(compositeBlue * 255)
            }

            imageAddress += imageBytesPerRow / MemoryLayout<UInt8>.size
            maskAddress += maskBytesPerRow / MemoryLayout<Float32>.size
        }

        CVPixelBufferUnlockBaseAddress(imageBuffer, writeFlags)
        CVPixelBufferUnlockBaseAddress(mask.buffer, CVPixelBufferLockFlags.readOnly)
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
        if sender.tag == 0 && isCameraAvailable {
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
            detectSegmentationMask(image: editedImage)

        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
            detectSegmentationMask(image: originalImage)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  ObjectRemovalDelegate+Extension.swift
//  Onboard
//
//  Created by Ali Dinç on 31/12/2021.
//

import UIKit
import Vision
import CoreML

protocol ObjectRemovalDelegate: AnyObject { }

extension ObjectRemovalDelegate {
    // MARK: - Public
    func removeBackgroundFromObjects(from inputImage: UIImage, for imageView: UIImageView) {
        guard let mlModel = try? DeepLabV3(configuration: .init()).model else { return }
        guard let visionModel = try? VNCoreMLModel(for: mlModel) else { return }
        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                   let segmentationmap = observations.first?.featureValue.multiArrayValue,
                   let segmentationMask = segmentationmap.image(min: 0, max: 1) {

                    imageView.image = segmentationMask.resizedImage(for: inputImage.size)!
                    self.maskInputImage(from: inputImage, for: imageView)
                }
            }
        }
        request.imageCropAndScaleOption = .scaleFill
        self.requestHandler(request: request, for: inputImage)
    }

    // MARK: - Private
    private func maskInputImage(from inputImage: UIImage, for imageView: UIImageView) {
        guard let bgImage = UIImage.imageFromColor(color: .yellow, size: inputImage.size, scale: inputImage.scale),
              let inputCgImage = inputImage.cgImage,
              let bgCgImage = bgImage.cgImage  else { return }

        let background = CIImage(cgImage: bgCgImage)
        let beginImage = CIImage(cgImage: inputCgImage)

        guard let imageViewCgImage = imageView.image?.cgImage else { return }
        let mask = CIImage(cgImage: imageViewCgImage)

        if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
            kCIInputImageKey: beginImage,
            kCIInputBackgroundImageKey: background,
            kCIInputMaskImageKey: mask])?.outputImage
        {

            let ciContext = CIContext(options: nil)
            let filteredImageRef = ciContext.createCGImage(compositeImage, from: compositeImage.extent)

            imageView.image = UIImage(cgImage: filteredImageRef!)
        }
    }
    private func requestHandler(request: VNCoreMLRequest, for inputImage: UIImage) {
        DispatchQueue.global().async {
            if let cgImage = inputImage.cgImage {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    try handler.perform([request])
                } catch {
                    print(error)
                }
            }
        }
    }
}

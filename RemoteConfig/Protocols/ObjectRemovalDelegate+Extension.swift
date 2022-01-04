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
    func removeBackgroundFromObjectsWithCoreML(from inputImage: UIImage, completion: @escaping (UIImage) -> Void) {
        guard let mlModel = try? DeepLabV3(configuration: .init()).model else { return }
        guard let visionModel = try? VNCoreMLModel(for: mlModel) else { return }
        let request = VNCoreMLRequest(model: visionModel) { request, _ in
            if let observations = request.results as? [VNCoreMLFeatureValueObservation],
               let segmentationmap = observations.first?.featureValue.multiArrayValue,
               let segmentationMask = segmentationmap.image(min: 0, max: 1) {

                guard let resizedMaskImage = segmentationMask.resizedImage(for: inputImage.size) else { return }
                completion(resizedMaskImage)
            }
        }
        request.imageCropAndScaleOption = .scaleFill
        self.requestHandler(request: request, for: inputImage)
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

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
    func removeBackgroundFromObjectsWithCoreML(from inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
#warning("Don't supress")
        guard let mlModel = try? DeepLabV3(configuration: .init()).model,
              let visionModel = try? VNCoreMLModel(for: mlModel) else {
            completion(nil)
            return
        }
        
        /*
             guard let mlModel = try? DeepLabV3(configuration: .init()).model,
                   let visionModel = try? VNCoreMLModel(for: mlModel) else {
                 completion(nil)
                 return
                 
             }
         */
        
        let request = VNCoreMLRequest(model: visionModel) { request, _ in
            if let observations = request.results as? [VNCoreMLFeatureValueObservation],
               let segmentationMap = observations.first?.featureValue.multiArrayValue,
               let segmentationMask = segmentationMap.image(min: 0, max: 1) {

#warning("Don't supress")
                guard let resizedMaskImage = segmentationMask.resizedImage(for: inputImage.size) else { completion(nil); return }
                completion(resizedMaskImage)
            }
        }
        request.imageCropAndScaleOption = .scaleFill

        DispatchQueue.global().async {
            if let cgImage = inputImage.cgImage {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    try handler.perform([request])
                } catch {
                    #warning("Check this, not sure if would supress")
                    completion(nil)
                }
            }
        }
    }
}

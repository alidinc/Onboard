//
//  FaceDetector.swift
//  Onboard
//
//  Created by Ali Dinç on 30/12/2021.
//

import Vision
import SevenAppsKit
import UIKit

class FaceDetector {
    static let shared = FaceDetector()
    private init() { }

    // MARK: - Methods
    func faceDetectRequest(for originalImage: UIImage, completion: @escaping (Result<VNFaceObservation, RCError>) -> Void) {
        let request = VNDetectFaceRectanglesRequest { request, error in
            if error != nil {
                completion(.failure(.unableToDetectFace))
            } else {
                DispatchQueue.main.async {
                    if let results = request.results as? [VNFaceObservation] {
                        guard let observation = results.first else { return }
                        results.isEmpty ? completion(.failure(.unableToDetectFace)) : completion(.success(observation))
                    } else {
                        completion(.failure(.unableToDetectFace))
                        print("FACE UNDETECTED!!!!")
                    }
                }
            }
        }
        self.performRequest(request, image: originalImage)
    }

    private func performRequest(_ request: VNDetectFaceRectanglesRequest, image: UIImage) {
        DispatchQueue.global().async {
            if let cgImage = image.cgImage {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    try handler.perform([request])
                } catch {
                    SAK.logger.error(error)
                }
            }
        }
    }
}

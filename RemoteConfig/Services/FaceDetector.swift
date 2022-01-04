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
    func faceDetectRequest(for originalImage: UIImage, completion: @escaping (Result<Bool, RCError>) -> Void) {
        let request = VNDetectFaceRectanglesRequest { request, error in
            if let _ = error {
                completion(.failure(.unableToDetectFace))
            } else {
                DispatchQueue.main.async {
                    if let results = request.results as? [VNFaceObservation] {
                        results.isEmpty ? completion(.failure(.unableToDetectFace)) : completion(.success(true))
                    } else {
                        print("FACE UNDETECTED!!!!")
                    }
                }
            }
        }
        self.performRequest(request, image: originalImage)
    }

    private func performRequest(_ request: VNDetectFaceRectanglesRequest, image: UIImage) {
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

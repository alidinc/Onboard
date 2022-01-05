//
//  FaceDetector.swift
//  Onboard
//
//  Created by Ali Dinç on 30/12/2021.
//

import Vision
import SevenAppsKit
import UIKit

enum Result<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

class FaceDetector {
    static let shared = FaceDetector()
    private init() { }

    // MARK: - Methods
    func faceDetectRequest(for originalImage: UIImage, completion: @escaping (Result<VNFaceObservation, RCError>) -> Void) {
        let request = VNDetectFaceRectanglesRequest { request, error in
            if error != nil {
                print("ERROR")
            } else {
                if let results = request.results as? [VNFaceObservation] {
                    guard let observation = results.first else { return }
                    results.isEmpty ? completion(.failure(.unableToDetectFace)) : completion(.success(observation))
                } else {
                    completion(.failure(.unableToDetectFace))
                }
            }
        }
        self.performRequest(request, image: originalImage)
    }

    private func performRequest(_ request: VNDetectFaceRectanglesRequest, image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
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

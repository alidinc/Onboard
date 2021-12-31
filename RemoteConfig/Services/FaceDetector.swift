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

    var hasDetectedFace: Bool?

    // MARK: - Public
    func faceDetectRequest(for originalImage: UIImage, in viewController: UIViewController) {
        let request = VNDetectFaceRectanglesRequest { request, error in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    if (request.results?.first as? VNFaceObservation) != nil {
                        self.hasDetectedFace = true
                        self.showAlert(with: "Face detected!", in: viewController)
                    } else {
                        self.hasDetectedFace = false
                        self.showAlert(with: "Not detected", in: viewController)
                    }
                }
            }
        }
        self.performRequest(request, image: originalImage)
    }

    // MARK: - Private
    private func performRequest(_ request: VNDetectFaceRectanglesRequest, image: UIImage) {
        DispatchQueue.global(qos: .background).async {
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

    private func showAlert(with message: String, in viewController: UIViewController) {
        SAK.UI.AlertControllerBuilder(message: message, actions: [.okay], style: .alert)
            .present(in: viewController, completion: nil)
    }
}

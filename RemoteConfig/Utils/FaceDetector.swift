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

    // MARK: - Public
    func faceDetectRequest(for originalImage: UIImage, in viewController: UIViewController) {
        let request = VNDetectFaceRectanglesRequest {  (req, error) in
            if let error = error {
                SAK.logger.error(error)
            }
            DispatchQueue.main.async {
                guard (((req.results?.first as? VNFaceObservation) != nil)) else {
                    self.showAlert(with: "No face detected!", in: viewController)
                    return
                }
                self.showAlert(with: "Face detected!", in: viewController)
            }
        }

        guard let cgImage = originalImage.cgImage  else { return }

        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                SAK.logger.error(error)
            }
        }
    }

    private func showAlert(with message: String, in viewController: UIViewController) {
        SAK.UI.AlertControllerBuilder(message: message, actions: [.okay], style: .alert)
            .present(in: viewController, completion: nil)
    }
}

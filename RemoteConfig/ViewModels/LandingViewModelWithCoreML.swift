//
//  LandingViewModelWithCoreML.swift
//  Onboard
//
//  Created by Ali Dinç on 29/12/2021.
//

import CoreML
import Vision
import UIKit

class LandingViewModelWithCoreML {

    let inputImage: UIImage!
    var outputImage: UIImage!

    init(inputImage: UIImage, outputImage: UIImage) {
        self.inputImage = inputImage
        self.outputImage = outputImage
    }

    func runVisionRequest(for image: UIImage) {

        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model)
        else { return }

        let request = VNCoreMLRequest(model: model) { request,_ in
            DispatchQueue.main.async {
                if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                   let segmentationmap = observations.first?.featureValue.multiArrayValue {

                    let segmentationMask = segmentationmap.image(min: 0, max: 1)
                    self.outputImage = segmentationMask!.resizedImage(for: image.size)!
                    self.maskInputImage()
                }
            }
        }
        request.imageCropAndScaleOption = .scaleFill
        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(cgImage: self.inputImage.cgImage!, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }

    func maskInputImage(){

        let bgImage = UIImage.imageFromColor(color: .blue, size: self.inputImage.size, scale: self.inputImage.scale)!

        let beginImage = CIImage(cgImage: inputImage.cgImage!)
        let background = CIImage(cgImage: bgImage.cgImage!)
        let mask = CIImage(cgImage: self.outputImage.cgImage!)

        if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
            kCIInputImageKey: beginImage,
            kCIInputBackgroundImageKey:background,
            kCIInputMaskImageKey:mask])?.outputImage
        {

            let ciContext = CIContext(options: nil)
            let filteredImageRef = ciContext.createCGImage(compositeImage, from: compositeImage.extent)

            self.outputImage = UIImage(cgImage: filteredImageRef!)
        }
    }

    //    var imageSegmentationModel = DeepLabV3()
    //    var request :  VNCoreMLRequest?
    //
    //    func setUpModel() {
    //            if let visionModel = try? VNCoreMLModel(for: imageSegmentationModel.model) {
    //                    request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
    //                    request?.imageCropAndScaleOption = .scaleFill
    //            } else {
    //                    fatalError()
    //            }
    //    }
    //
    //    func predict() {
    //            DispatchQueue.global(qos: .userInitiated).async {
    //                guard let request = self.request else { fatalError() }
    //                let handler = VNImageRequestHandler(cgImage: (self.originalImage?.cgImage)!, options: [:])
    //                do {
    //                    try handler.perform([request])
    //                } catch {
    //                    print(error)
    //                }
    //            }
    //       }
    //
    //    func visionRequestDidComplete(request: VNRequest, error: Error?) {
    //            DispatchQueue.main.async {
    //                if let observations = request.results as? [VNCoreMLFeatureValueObservation],
    //                    let segmentationmap = observations.first?.featureValue.multiArrayValue {
    //                    self.maskImage = segmentationmap.image(min: 0, max: 255)
    //                    print(self.maskImage!.size)
    //
    //                    self.maskImage = self.maskImage?.resizedImage(for: self.originalImage!.size)
    //                    if let image:UIImage = self.maskOriginalImage(){
    //                        print("Success")
    //                        self.imageView.image = image
    //                    }
    //                    self.startSegmentationButton.setTitle("Done", for: .normal)
    //                }
    //            }
    //
    //        }
    //
    //    func maskOriginalImage() -> UIImage? {
    //            if(self.maskImage != nil && self.originalImage != nil){
    //                let maskReference = self.maskImage?.cgImage!
    //                let imageMask = CGImage(maskWidth: maskReference!.width,
    //                                        height: maskReference!.height,
    //                                        bitsPerComponent: maskReference!.bitsPerComponent,
    //                                        bitsPerPixel: maskReference!.bitsPerPixel,
    //                                        bytesPerRow: maskReference!.bytesPerRow,
    //                                        provider: maskReference!.dataProvider!, decode: nil, shouldInterpolate: true)
    //
    //                let maskedReference = self.originalImage?.cgImage!.masking(imageMask!)
    //                return UIImage(cgImage: maskedReference!)
    //
    //            }
    //            return nil
    //        }

}

extension UIImage {
    class func imageFromColor(color: UIColor, size: CGSize=CGSize(width: 1, height: 1), scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func resizedImage(for size: CGSize) -> UIImage? {
        let image = self.cgImage
        print(size)
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image!.bitsPerComponent,
                                bytesPerRow: Int(size.width),
                                space: image?.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                bitmapInfo: image!.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(image!, in: CGRect(origin: .zero, size: size))

        guard let scaledImage = context?.makeImage() else { return nil }

        return UIImage(cgImage: scaledImage)
    }

}

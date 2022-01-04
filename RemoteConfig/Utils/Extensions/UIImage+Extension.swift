//
//  UIImage+Extension.swift
//  Onboard
//
//  Created by Ali Dinç on 29/12/2021.

import UIKit

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

    func fixOrientation() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}

extension UIImage {
    func maskInputImage(from inputImage: UIImage) -> UIImage? {
        guard let bgImage = UIImage.imageFromColor(color: .yellow, size: inputImage.size, scale: inputImage.scale),
              let inputCgImage = inputImage.cgImage,
              let bgCgImage = bgImage.cgImage  else { return nil }

        let background = CIImage(cgImage: bgCgImage)
        let beginImage = CIImage(cgImage: inputCgImage)

        guard let outputCgImage = self.cgImage else { return nil }
        let mask = CIImage(cgImage: outputCgImage)

        guard let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
            kCIInputImageKey: beginImage,
            kCIInputBackgroundImageKey: background,
            kCIInputMaskImageKey: mask])?.outputImage
        else { return nil }

        let ciContext = CIContext(options: nil)
        let filteredImageRef = ciContext.createCGImage(compositeImage, from: compositeImage.extent)

        return UIImage(cgImage: filteredImageRef!)

    }
}

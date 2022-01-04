//
//  SelfieRemovalDelegate+Extension.swift
//  Onboard
//
//  Created by Ali Dinç on 31/12/2021.
//

import MLKit
import UIKit

protocol SelfieRemovalDelegate: AnyObject { }

extension SelfieRemovalDelegate {
    func removeBackgroundFromSelfieWithMLKit(on image: UIImage?, for imageView: UIImageView, with segmenter: Segmenter) {
        guard let image = image else { return }

        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation

        segmenter.process(visionImage) { [weak self] mask, error in
            guard let self = self, error == nil, let mask = mask else { return }
            guard let imageBuffer = self.createImageBuffer(from: image) else { return }

            self.applySegmentationMask(
                mask: mask, to: imageBuffer,
                backgroundColor: UIColor.purple.withAlphaComponent(0.5),
                foregroundColor: nil)
            let maskedImage = self.createUIImage(from: imageBuffer, orientation: .up)
            imageView.image = maskedImage
        }
    }

    // MARK: - Private methods
    private func createUIImage(from imageBuffer: CVImageBuffer, orientation: UIImage.Orientation) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)
    }

    private func createImageBuffer(from image: UIImage) -> CVImageBuffer? {
        guard let cgImage = image.cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height

        var buffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, nil, &buffer)
        guard let imageBuffer = buffer else { return nil }

        let flags = CVPixelBufferLockFlags(rawValue: 0)
        CVPixelBufferLockBaseAddress(imageBuffer, flags)

        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let context = CGContext(
          data: baseAddress, width: width, height: height, bitsPerComponent: 8,
          bytesPerRow: bytesPerRow, space: colorSpace,
          bitmapInfo: (CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue))

        if let context = context {
          let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
          context.draw(cgImage, in: rect)
          CVPixelBufferUnlockBaseAddress(imageBuffer, flags)
          return imageBuffer
        } else {
          CVPixelBufferUnlockBaseAddress(imageBuffer, flags)
          return nil
        }
      }

    private func applySegmentationMask(mask: SegmentationMask, to imageBuffer: CVImageBuffer, backgroundColor: UIColor?, foregroundColor: UIColor?) {
        let width = CVPixelBufferGetWidth(mask.buffer)
        let height = CVPixelBufferGetHeight(mask.buffer)

        if backgroundColor == nil && foregroundColor == nil { return }

        let writeFlags = CVPixelBufferLockFlags(rawValue: 0)
        CVPixelBufferLockBaseAddress(imageBuffer, writeFlags)
        CVPixelBufferLockBaseAddress(mask.buffer, CVPixelBufferLockFlags.readOnly)

        let maskBytesPerRow = CVPixelBufferGetBytesPerRow(mask.buffer)
        var maskAddress = CVPixelBufferGetBaseAddress(mask.buffer)!.bindMemory(to: Float32.self, capacity: maskBytesPerRow * height)

        let imageBytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        var imageAddress = CVPixelBufferGetBaseAddress(imageBuffer)!.bindMemory(to: UInt8.self, capacity: imageBytesPerRow * height)

        var redFG: CGFloat = 0.0
        var greenFG: CGFloat = 0.0
        var blueFG: CGFloat = 0.0
        var alphaFG: CGFloat = 0.0
        var redBG: CGFloat = 0.0
        var greenBG: CGFloat = 0.0
        var blueBG: CGFloat = 0.0
        var alphaBG: CGFloat = 0.0

        let backgroundColor = backgroundColor != nil ? backgroundColor : .clear
        let foregroundColor = foregroundColor != nil ? foregroundColor : .clear
        backgroundColor!.getRed(&redBG, green: &greenBG, blue: &blueBG, alpha: &alphaBG)
        foregroundColor!.getRed(&redFG, green: &greenFG, blue: &blueFG, alpha: &alphaFG)

        for _ in 0...(height - 1) {
            for col in 0...(width - 1) {
                let pixelOffset = col * 4
                let blueOffset = pixelOffset
                let greenOffset = pixelOffset + 1
                let redOffset = pixelOffset + 2
                let alphaOffset = pixelOffset + 3

                let maskValue: CGFloat = CGFloat(maskAddress[col])
                let backgroundRegionRatio: CGFloat = 1.0 - maskValue
                let foregroundRegionRatio = maskValue

                let originalPixelRed: CGFloat =
                CGFloat(imageAddress[redOffset]) / 255
                let originalPixelGreen: CGFloat =
                CGFloat(imageAddress[greenOffset]) / 255
                let originalPixelBlue: CGFloat =
                CGFloat(imageAddress[blueOffset]) / 255
                let originalPixelAlpha: CGFloat =
                CGFloat(imageAddress[alphaOffset]) / 255

                let redOverlay = redBG * backgroundRegionRatio + redFG * foregroundRegionRatio
                let greenOverlay = greenBG * backgroundRegionRatio + greenFG * foregroundRegionRatio
                let blueOverlay = blueBG * backgroundRegionRatio + blueFG * foregroundRegionRatio
                let alphaOverlay = alphaBG * backgroundRegionRatio + alphaFG * foregroundRegionRatio

                // Calculate composite color component values.
                // Derived from https://en.wikipedia.org/wiki/Alpha_compositing#Alpha_blending
                let compositeAlpha: CGFloat = ((1.0 - alphaOverlay) * originalPixelAlpha) + alphaOverlay
                var compositeRed: CGFloat = 0.0
                var compositeGreen: CGFloat = 0.0
                var compositeBlue: CGFloat = 0.0
                // Only perform rgb blending calculations if the output alpha is > 0. A zero-value alpha
                // means none of the color channels actually matter, and would introduce division by 0.
                if abs(compositeAlpha) > CGFloat(Float.ulpOfOne) {
                    compositeRed =
                    (((1.0 - alphaOverlay) * originalPixelAlpha * originalPixelRed)
                     + (alphaOverlay * redOverlay)) / compositeAlpha
                    compositeGreen =
                    (((1.0 - alphaOverlay) * originalPixelAlpha * originalPixelGreen)
                     + (alphaOverlay * greenOverlay)) / compositeAlpha
                    compositeBlue =
                    (((1.0 - alphaOverlay) * originalPixelAlpha * originalPixelBlue)
                     + (alphaOverlay * blueOverlay)) / compositeAlpha
                }

                imageAddress[redOffset] = UInt8(compositeRed * 255)
                imageAddress[greenOffset] = UInt8(compositeGreen * 255)
                imageAddress[blueOffset] = UInt8(compositeBlue * 255)
            }

            imageAddress += imageBytesPerRow / MemoryLayout<UInt8>.size
            maskAddress += maskBytesPerRow / MemoryLayout<Float32>.size
        }

        CVPixelBufferUnlockBaseAddress(imageBuffer, writeFlags)
        CVPixelBufferUnlockBaseAddress(mask.buffer, CVPixelBufferLockFlags.readOnly)
    }
}

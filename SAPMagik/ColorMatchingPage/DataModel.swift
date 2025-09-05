//
//  DataModel.swift
//  CameraPreview
//
//  Created by Jia Chen Yee on 2/8/25.
//

import Foundation
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }

    var averageColor: UIColor? {
        let areaAverageFilter = CIFilter.areaAverage()
        areaAverageFilter.inputImage = self
        areaAverageFilter.extent = self.extent

        guard let outputImage = areaAverageFilter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )

        return UIColor(
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            alpha: CGFloat(bitmap[3]) / 255
        )
    }
}


extension Color {
    static var random: Color {
        Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}


@Observable
final class DataModel {
    let camera = Camera()
    
    var ciImage: CIImage?
    var swiftUIImage: Image?

    init() {
        Task {
            await camera.start()
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream

        for await image in imageStream {
            Task { @MainActor in
                self.ciImage = image
                self.swiftUIImage = image.image
            }
        }
    }
}

fileprivate extension Image.Orientation {
    
    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

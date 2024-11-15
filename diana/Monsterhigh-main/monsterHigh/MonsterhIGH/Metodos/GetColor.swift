//
//  GetColor.swift
//  MonsterhIGH
//
//  Created by alumno on 11/15/24.
//

import UIKit

extension UIImage {
    func getDominantColor() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }

        // Reducir la imagen a una versión más pequeña para procesarla más rápido
        let size = CGSize(width: 50, height: 50)
        let context = CIContext()
        let cgImage = context.createCGImage(inputImage, from: inputImage.extent)
        let scaledImage = UIImage(cgImage: cgImage!).resize(to: size)
        
        // Crear un mapa de colores
        var colorCount: [UIColor: Int] = [:]
        guard let resizedCGImage = scaledImage.cgImage else { return nil }
        let width = resizedCGImage.width
        let height = resizedCGImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let totalBytes = height * bytesPerRow
        var rawData = [UInt8](repeating: 0, count: totalBytes)

        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        let context2 = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        context2?.draw(resizedCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        // Procesar los colores
        for x in 0..<width {
            for y in 0..<height {
                let offset = (y * bytesPerRow) + (x * bytesPerPixel)
                let red = CGFloat(rawData[offset]) / 255.0
                let green = CGFloat(rawData[offset + 1]) / 255.0
                let blue = CGFloat(rawData[offset + 2]) / 255.0
                let alpha = CGFloat(rawData[offset + 3]) / 255.0

                if alpha > 0.5 { // Ignorar colores transparentes
                    let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                    colorCount[color, default: 0] += 1
                }
            }
        }

        // Encontrar el color más frecuente
        let dominantColor = colorCount.max(by: { $0.value < $1.value })?.key
        return dominantColor
    }

    func resize(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

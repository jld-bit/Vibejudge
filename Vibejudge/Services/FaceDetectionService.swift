import Foundation
#if canImport(ImageIO)
import ImageIO
#endif

#if canImport(Vision)
import Vision
#endif

final class FaceDetectionService {
    func containsFace(in imageData: Data?) async -> Bool {
        guard let imageData else { return false }

        #if canImport(Vision)
        guard let image = CGImageSourceCreateWithData(imageData as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(image, 0, nil) else {
            return false
        }

        return await withCheckedContinuation { continuation in
            let request = VNDetectFaceRectanglesRequest { request, _ in
                let count = (request.results as? [VNFaceObservation])?.count ?? 0
                continuation.resume(returning: count > 0)
            }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(returning: false)
            }
        }
        #else
        return !imageData.isEmpty
        #endif
    }
}

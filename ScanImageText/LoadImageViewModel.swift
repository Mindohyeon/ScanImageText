import Foundation
import AppKit
import Vision
import CoreImage

class LoadImageViewModel {
    func recognizeTextInImage(_ image: NSImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage(
            forProposedRect: nil,
            context: nil,
            hints: nil
        ) else {
            return
        }
        
        let requestHandler = VNImageRequestHandler(
            cgImage: cgImage,
            options: [:]
        )
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("텍스트 인식 오류: \(error.localizedDescription)")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            var recognizedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                recognizedText += topCandidate.string + "\n"
            }
            
            DispatchQueue.main.async {
                completion(recognizedText)
            }
        }
        
        /// 언어를 인식하는 우선순위 설정
        if #available(iOS 16.0, *) {
            request.revision = VNRecognizeTextRequestRevision3
            request.recognitionLanguages = ["ko-KR"]
        } else {
            request.recognitionLanguages = ["en-US"]
        }
        /// 정확도 우선
        request.recognitionLevel = .accurate
        /// 언어를 인식하고 수정하는 과정을 거침.
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("텍스트 인식 오류: \(error.localizedDescription)")
        }
    }
}

import Foundation
import AppKit
import Vision

protocol ViewModelable: ObservableObject {
  associatedtype Action
  associatedtype State
  
  var state: State { get }
  
  func action(_ action: Action)
}

class LoadImageViewModel: ViewModelable {
    @Published var state: State
    
    enum Action {
        case dragDropImageButton(image: NSImage)
    }
    
    enum State {
        case resultText(String)
    }
    
    init() {
        self.state = .resultText("")
    }
    
    func action(_ action: Action) {
        switch action {
        case .dragDropImageButton(let image):
            state = .resultText(recognizeTextInImage(image))
        }
    }
    
    func recognizeTextInImage(_ image: NSImage) -> String {
        guard let cgImage = image.cgImage(
            forProposedRect: nil,
            context: nil,
            hints: nil
        ) else {
            return ""
        }
        
        let requestHandler = VNImageRequestHandler(
            cgImage: cgImage,
            options: [:]
        )
        
        var recognizedText = ""
        
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("텍스트 인식 오류: \(error.localizedDescription)")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                recognizedText += topCandidate.string + "\n"
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
        
        return recognizedText
    }
}

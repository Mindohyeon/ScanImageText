import SwiftUI
import Vision
import CoreImage

struct ContentView: View {
    @State private var scannedText: String = ""
    @State private var isScanning: Bool = false
    @State private var completedScanneText: String = ""
    @State private var isHiddenForResultTexts: Bool = true
    
    private let pasteboard = NSPasteboard.general
    
    var body: some View {
        VStack {
            if isScanning {
                Text("스캔 중...")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            } else {
                if !isHiddenForResultTexts {
                    TextView(text: $scannedText)
                        .foregroundColor(.white)
                        .font(.body)
                        .frame(maxHeight: .infinity)
                        .fixedSize(horizontal: false, vertical: false)
                        .multilineTextAlignment(.center)
                        .layoutPriority(1)
                }
            }
            
            ImageDropView(scannedText: $scannedText, isScanning: $isScanning, isHiddenForResultTexts: $isHiddenForResultTexts)
                .frame(maxWidth: 300, maxHeight: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ImageDropView: View {
    @Binding var scannedText: String
    @Binding var isScanning: Bool
    @Binding var isHiddenForResultTexts: Bool
    
    var body: some View {
        VStack {
            Text("이미지를 여기에 드래그 앤 드롭하세요.")
                .font(.headline)
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
                .onDrop(of: ["public.image"],
                        isTargeted: nil) { providers in
                    self.loadImage(from: providers)
                    return true
                }
        }
    }
    
    private func loadImage(from providers: [NSItemProvider]) {
        guard let provider = providers.first else { return }
        
        if provider.hasItemConformingToTypeIdentifier("public.image") {
            provider.loadItem(forTypeIdentifier: "public.image") { item, error in
                if let url = item as? URL,
                   let image = NSImage(contentsOf: url) {
                    Task {
                        self.isScanning = true
                        self.scannedText = ""
                        await recognizeTextInImage(image)
                    }
                }
            }
        }
    }
    
    private func recognizeTextInImage(_ image: NSImage) {
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
                print(recognizedText)
                self.scannedText = recognizedText
                self.isScanning = false
                self.isHiddenForResultTexts = false
            }
        }
        
        /// 언어를 인식하는 우선순위 설정
        if #available(iOS 16.0, *) {
            request.revision = VNRecognizeTextRequestRevision3
            request.recognitionLanguages = ["ko-KR"]
        } else {
            request.recognitionLanguages = ["en-US"]
        }
        /// 정확도와 속도 중 어느 것을 중점적으로 처리할 것인지
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

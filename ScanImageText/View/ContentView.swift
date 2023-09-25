import SwiftUI
import Combine
import Vision
import CoreImage

struct ContentView: View {
    @State private var scannedText: String = ""
    @State private var isScanning: Bool = false
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
            
            ImageDropView(scannedText: $scannedText,
                          isScanning: $isScanning,
                          isHiddenForResultTexts: $isHiddenForResultTexts)
            .frame(maxWidth: 300, maxHeight: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ImageDropView: View {
    @Binding var scannedText: String
    @Binding var isScanning: Bool
    @Binding var isHiddenForResultTexts: Bool
    
    @ObservedObject var viewModel = LoadImageViewModel()
    
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
                    self.isScanning = true
                    self.scannedText = ""
                    
                    viewModel.action(.dragDropImageButton(image: image))
                    bindSate()
                }
            }
        }
    }
    
    private func bindSate() {
        switch viewModel.state {
        case .resultText(let recognizedText):
            DispatchQueue.main.async {
                scannedText = recognizedText
                isScanning = false
                isHiddenForResultTexts = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

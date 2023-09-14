import Vision
import VisionKit


class OCRViewModel: ObservableObject {
  // MARK: - Properties
  @Published var OCRString: String?
  
  // MARK: - Methods
//    func recognaizeText(image: UIImage) {
//      guard let Image = image.cgImage else { fatalError("이미지 오류")}
//      
//      let handler = VNImageRequestHandler(cgImage: Image, options: [:])
//    }
}

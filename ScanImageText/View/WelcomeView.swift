import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel = ContentViewModel()
    init() {
        viewModel.checkAuthorization()
    }
    
    var body: some View {
        HStack {
            NavigationLink(destination: CameraView()) {
                Text("Camera")
                    .tint(.white)
                    .font(.title)
                    .frame(width: 200, height: 100)
                    .padding()
            }
            
            NavigationLink(destination: ScanImageView()) {
                Text("Drag & Drop")
                    .tint(.white)
                    .font(.title)
                    .frame(width: 200, height: 100)
                    .padding()
            }
            
            PlayerContainerView(captureSession: viewModel.captureSession)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

#Preview {
    WelcomeView()
}

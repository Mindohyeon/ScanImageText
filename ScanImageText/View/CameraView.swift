import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    init() {
        viewModel.checkAuthorization()
    }
    
    var body: some View {
        PlayerContainerView(captureSession: viewModel.captureSession)
            .clipShape(Circle())
    }
}

#Preview {
    CameraView()
}

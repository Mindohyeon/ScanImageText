import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @EnvironmentObject var settings: UserSettings
    
    init() {
        viewModel.checkAuthorization()
    }
    
    var body: some View {
        PlayerContainerView(captureSession: viewModel.captureSession,
                            settings: settings)
            .clipShape(Circle())
    }
    
    var shape: some Shape {
        switch settings.shape {
        case .circle:
            return AnyShape(Circle())
        case .rectangle:
            return AnyShape(RoundedRectangle(cornerRadius: 25.0))
        }
    }
}

#Preview {
    CameraView()
}

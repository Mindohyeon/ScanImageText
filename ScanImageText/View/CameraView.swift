import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @EnvironmentObject var settings: UserSettings
    
    init() {
        viewModel.checkAuthorization()
    }
    
    var body: some View {
        VStack {
            
        PlayerContainerView(captureSession: viewModel.captureSession,
                            settings: settings)
            .clipShape(Circle())
        }
    }
    
    var shape: some Shape {
        print("fasdf")
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

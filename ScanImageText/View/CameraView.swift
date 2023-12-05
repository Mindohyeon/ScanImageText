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
            .clipShape(shape)
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

struct AnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }

    private let _path: (CGRect) -> Path
}

#Preview {
    CameraView()
}

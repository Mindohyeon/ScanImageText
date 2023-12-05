import SwiftUI
import Vision
import AppKit
import AVFoundation
import Combine

class PlayerView: NSView {
    
    private weak var settings: UserSettings?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private lazy var cancellables = Set<AnyCancellable>()

    init(captureSession: AVCaptureSession, settings: UserSettings? = nil) {
        self.settings = settings
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        super.init(frame: .zero)

        setupLayer()
    }

    func setupLayer() {

        previewLayer?.frame = self.frame
        previewLayer?.contentsGravity = .resizeAspectFill
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.automaticallyAdjustsVideoMirroring = false
        
        layer = previewLayer
        
        settings?.$isMirroring
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isMirroring in
                self?.previewLayer?.connection?.isVideoMirrored = isMirroring
            }
            .store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct PlayerContainerView: NSViewRepresentable {
    typealias NSViewType = PlayerView

    let settings: UserSettings
    let captureSession: AVCaptureSession

    init(captureSession: AVCaptureSession, settings: UserSettings) {
        self.captureSession = captureSession
        self.settings = settings
    }

    func makeNSView(context: Context) -> PlayerView {
        return PlayerView(captureSession: captureSession, settings: settings)
    }

    func updateNSView(_ nsView: PlayerView, context: Context) { }
}

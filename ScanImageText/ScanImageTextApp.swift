import SwiftUI

@main
struct ScanImageTextApp: App {
    private var settings: UserSettings = UserSettings.init()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
                    .environmentObject(settings)
            }
        }
        MenuBarExtra("", systemImage: "text.alignleft") {
            Button("Rectangle Shape") {
                settings.shape = .rectangle
            }
            Button("Circle Shape") {
                settings.shape = .circle
            }
            Button("Mirror camera") {
                settings.isMirroring.toggle()
            }
            
            Divider()
            
            Button("Quit") {
                exit(0)
            }
        }
    }
}

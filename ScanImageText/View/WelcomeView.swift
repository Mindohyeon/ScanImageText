import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var settings: UserSettings
    var body: some View {
        HStack {
            NavigationLink(destination: CameraView().environmentObject(settings)) {
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

#Preview {
    WelcomeView()
}

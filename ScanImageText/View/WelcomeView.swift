import SwiftUI

struct WelcomeView: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Text("Camera")
                    .font(.title)
                    .frame(width: 200, height: 100)
            }
            .padding()
            
            
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

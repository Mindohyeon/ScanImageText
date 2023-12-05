import Foundation

class UserSettings: ObservableObject {
    @Published var shape = Shape.circle
    @Published var isMirroring = false
    
    enum Shape {
        case circle
        case rectangle
    }
}

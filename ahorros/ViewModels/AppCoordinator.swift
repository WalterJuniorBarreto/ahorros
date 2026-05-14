import SwiftUI

import Combine
class AppCoordinator: ObservableObject {
    
    
    @Published var isSplashScreenActive: Bool = true
    
    func startAppFlow() {
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.isSplashScreenActive = false
            }
        }
    }
}


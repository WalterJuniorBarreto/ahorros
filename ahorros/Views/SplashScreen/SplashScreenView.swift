import SwiftUI

struct SplashScreenView: View {
   
    @State private var scaleEffect: CGFloat = 1.0
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            Image("logo-ahorros")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                
   
                .opacity(opacity)
                
                .scaleEffect(scaleEffect)
                
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.opacity = 1.0
                    }
                    
                  
                    let heartbeatAnimation = Animation
                        .easeInOut(duration: 0.7)
                        .repeatForever(autoreverses: true)
                    
                    withAnimation(heartbeatAnimation) {
                        self.scaleEffect = 1.15
                    }
                }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

import SwiftUI

struct AnalyzingProfileView: View {
    @State private var analysisProgress: Int = 0
    @State private var isAnimatingRing: Bool = false
    
    let steps = [
        "Analizando respuestas...",
        "Creando perfil financiero...",
        "Personalizando experiencia...",
        "¡Listo para empezar!"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
           
            ProgressView(value: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                .padding(.top, 10)
                .padding(.bottom, 40)
            
            Text("Analizando tu perfil")
                .font(.system(size: 34, weight: .bold))
                .padding(.bottom, 12)
            
            Text("Estamos adaptando CASHFLOW especialmente para ti.")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 60)
            
            CenterAnimationView(isAnimating: $isAnimatingRing, isComplete: analysisProgress == 4)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 60)
            
            VStack(alignment: .leading, spacing: 25) {
                ForEach(0..<4, id: \.self) { index in
                    HStack(spacing: 15) {
                     
                        Image(systemName: getIconForStep(index: index))
                            .font(.title2)
                            .foregroundColor(getColorForStep(index: index))
                            
                            .rotationEffect(Angle(degrees: analysisProgress == index && isAnimatingRing ? 360 : 0))
                            .animation(analysisProgress == index ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .default, value: isAnimatingRing)
                        
                        Text(steps[index])
                            .font(.system(size: 18, weight: analysisProgress >= index ? .semibold : .regular))
                            .foregroundColor(analysisProgress >= index ? .black : .gray.opacity(0.4))
                    }
                    .animation(.easeInOut(duration: 0.4), value: analysisProgress)
                }
            }
            
            Spacer()
            
         
            if analysisProgress == 4 {
                NavigationLink(destination: ComparisonView()) {
                    Text("Siguiente")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.black)
                        .cornerRadius(25)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
          
                Color.clear.frame(height: 56)
            }
        }
        .padding(.horizontal, 30)
        .navigationBarHidden(true)
        .onAppear {
            startSimulation()
        }
    }
    
    
    func getIconForStep(index: Int) -> String {
        if analysisProgress > index { return "checkmark.circle.fill" }
        if analysisProgress == index { return "circle.dashed" }
        return "circle"
    }
    
    func getColorForStep(index: Int) -> Color {
        if analysisProgress > index { return .black }
        if analysisProgress == index { return .gray }
        return .gray.opacity(0.3)
    }
    
    func startSimulation() {
        isAnimatingRing = true
        
 
        let delayPerStep = 1.5
        
        for i in 1...4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (delayPerStep * Double(i))) {
                withAnimation {
                    analysisProgress = i
                }
            }
        }
    }
}

struct CenterAnimationView: View {
    @Binding var isAnimating: Bool
    var isComplete: Bool
    
    var body: some View {
        ZStack {
            if isComplete {
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.black)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 6)
                    .frame(width: 90, height: 90)
                
                Circle()
                    .trim(from: 0.0, to: 0.65)
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 90, height: 90)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false), value: isAnimating)
                
                Image(systemName: "cpu")
                    .font(.system(size: 28))
                    .foregroundColor(.black)
                    .scaleEffect(isAnimating ? 1.15 : 0.85)
                    .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
            }
        }
    }
}

struct AnalyzingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzingProfileView()
    }
}

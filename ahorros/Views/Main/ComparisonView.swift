import SwiftUI

struct ComparisonView: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userAge") var userAge: Int = 21
    @AppStorage("profileQ2") var answerQ2: String = ""
    @AppStorage("profileQ3") var answerQ3: String = ""
    @State private var isShowingGoodNews = false
    @State private var userBarHeight: CGFloat = 0
    @State private var averageBarHeight: CGFloat = 0
    @State private var opacityLevel: Double = 0
    @State private var navigateToContract = false
    
    var currentScore: Int {
        var baseScore = 30
        if answerQ2.contains("siempre") { baseScore += 25 }
        else if answerQ2.contains("A veces") { baseScore += 10 }
        
        if answerQ3.contains("Motivado") { baseScore += 15 }
        else if answerQ3.contains("Ansioso") { baseScore -= 10 }
        
        return min(max(baseScore, 15), 90)
    }
    
    var averageScore: Int {
        return userAge <= 25 ? 45 : 55
    }
    
    var projectedScore: Int {
        return min(currentScore + 45, 96)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ProgressView(value: isShowingGoodNews ? 1.0 : 0.8)
                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                .padding(.top, 10)
                .padding(.bottom, 40)
                .animation(.easeInOut, value: isShowingGoodNews)
            
            HStack {
                Spacer()
                Image(systemName: isShowingGoodNews ? "chart.line.uptrend.xyaxis.circle.fill" : "scale.3d")
                    .font(.system(size: 60))
                    .foregroundColor(isShowingGoodNews ? .green : .black)
                    .padding(.bottom, 20)
                    .animation(.spring(), value: isShowingGoodNews)
                Spacer()
            }
            
            Text(isShowingGoodNews ? "Tu proyección a 66 días" : "El punto de partida")
                .font(.system(size: 30, weight: .bold))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 12)
            
            Text(isShowingGoodNews
                 ? "Estudios demuestran que toma 66 días formar un hábito. Usando CASHFLOW, superarás ampliamente el promedio de personas de \(userAge) años."
                 : "Analizamos tus respuestas. Actualmente tienes un índice de salud financiera del \(currentScore)%, comparado con el \(averageScore)% del promedio.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .padding(.bottom, 50)
                .frame(height: 80)
            
            HStack(alignment: .bottom, spacing: 40) {
                Spacer()
                
                VStack {
                    Text("\(isShowingGoodNews ? projectedScore : currentScore)%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .opacity(opacityLevel)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isShowingGoodNews ? Color.green : Color.red)
                        .frame(width: 90, height: userBarHeight)
                    
                    Text("Tú")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    Text("\(averageScore)%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .opacity(opacityLevel)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black)
                        .frame(width: 90, height: averageBarHeight)
                    
                    Text("Promedio")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .frame(height: 250)
            
            Spacer()
            
            Button(action: {
                            if !isShowingGoodNews {
                                triggerPhaseTwoAnimation()
                            } else {
                                navigateToContract = true
                            }
                        }) {
                            Text(isShowingGoodNews ? "Comenzar mi plan" : "Ver proyección")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.black)
                                .cornerRadius(25)
                        }
                        .padding(.bottom, 50)
                        
                        NavigationLink(destination: ContractView(), isActive: $navigateToContract) {
                            EmptyView()
                        }
        }
        .padding(.horizontal, 30)
        .navigationBarHidden(true)
        .onAppear {
            triggerPhaseOneAnimation()
        }
    }
    
    
    func triggerPhaseOneAnimation() {
        userBarHeight = 0
        averageBarHeight = 0
        opacityLevel = 0
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
            userBarHeight = CGFloat(currentScore) * 2.0
            averageBarHeight = CGFloat(averageScore) * 2.0
            opacityLevel = 1.0
        }
    }
    
    func triggerPhaseTwoAnimation() {
        isShowingGoodNews = true
        opacityLevel = 0
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            userBarHeight = CGFloat(projectedScore) * 2.0  
            opacityLevel = 1.0
        }
    }
}

struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonView()
    }
}

import SwiftUI

struct ContractView: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("profileQ1") var answerQ1: String = ""
    @AppStorage("profileQ2") var answerQ2: String = ""
    
    @State private var pressProgress: CGFloat = 0.0
    @State private var isPressing: Bool = false
    @State private var isContractAccepted: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            ProgressView(value: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                .padding(.top, 10)
                .padding(.bottom, 30)
                .padding(.horizontal, 30)
            
            Text("Contrato con \(userName)")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 25)
            
            VStack(spacing: 16) {
                ContractItemView(
                    icon: "target",
                    text: "Me comprometo a enfocar mis esfuerzos en mi objetivo principal: \(formatGoal(answerQ1))."
                )
                
                ContractItemView(
                    icon: "list.clipboard.fill",
                    text: "Mejoraré mi hábito financiero. Actualmente registro mis gastos '\(formatHabit(answerQ2))', pero usaré la app para tener control total."
                )
                
                ContractItemView(
                    icon: "chart.line.uptrend.xyaxis",
                    text: "Analizaré mi progreso con estadísticas detalladas y me mantendré organizado."
                )
                
                ContractItemView(
                    icon: "star.fill",
                    text: "Invertiré en mí mismo y creceré económicamente cada día."
                )
            }
            .padding(.horizontal, 25)
            
            Spacer()
            
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                        .frame(width: 90, height: 90)
                    
                    Circle()
                        .trim(from: 0.0, to: pressProgress)
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(-90))
                    
                    Image(systemName: "touchid")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(isPressing ? .black : .gray)
                        .scaleEffect(isPressing ? 0.9 : 1.0)
                }
                .gesture(
                    LongPressGesture(minimumDuration: 1.5)
                        .onChanged { _ in
                            withAnimation(.easeInOut(duration: 1.5)) {
                                pressProgress = 1.0
                                isPressing = true
                            }
                        }
                        .onEnded { _ in
                            isContractAccepted = true
                        }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { _ in
                            if !isContractAccepted {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    pressProgress = 0.0
                                    isPressing = false
                                }
                            }
                        }
                )
                
                Text(isContractAccepted ? "¡Contrato Firmado!" : "Mantén presionado\npara aceptar")
                    .font(.headline)
                    .foregroundColor(isContractAccepted ? .green : .black)
                    .multilineTextAlignment(.center)
                
                Text("Las investigaciones muestran que comprometerse con contratos como este mejora la responsabilidad y los resultados.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
            }
            .padding(.bottom, 40)
            
            NavigationLink(destination: SavingGoalView(), isActive: $isContractAccepted) {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
    }
    
    func formatGoal(_ goal: String) -> String {
        let lowercased = goal.lowercased()
        if lowercased.contains("ahorrar") { return "ahorrar más dinero" }
        if lowercased.contains("invertir") { return "aprender a invertir" }
        if lowercased.contains("deudas") { return "pagar mis deudas" }
        return "mejorar mis finanzas"
    }
    
    func formatHabit(_ habit: String) -> String {
        let lowercased = habit.lowercased()
        if lowercased.contains("siempre") { return "siempre" }
        if lowercased.contains("veces") { return "a veces" }
        if lowercased.contains("nunca") { return "casi nunca" }
        return "poco"
    }
}

struct ContractItemView: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .frame(width: 30)
            
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}

struct ContractView_Previews: PreviewProvider {
    static var previews: some View {
        ContractView()
    }
}

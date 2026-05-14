import SwiftUI

struct FinancialProfileView: View {
    @State private var currentStep: Int = 1
    
    @AppStorage("profileQ1") var answerQ1: String = ""
    @AppStorage("profileQ2") var answerQ2: String = ""
    @AppStorage("profileQ3") var answerQ3: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(spacing: 8) {
                ForEach(1...3, id: \.self) { step in
                    Rectangle()
                        .fill(step <= currentStep ? Color.black : Color.gray.opacity(0.2))
                        .frame(height: 4)
                        .cornerRadius(2)
                        .animation(.easeInOut, value: currentStep)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
            
            Text("Conoce tu perfil")
                .font(.system(size: 34, weight: .bold))
                .padding(.bottom, 10)
            
            Text("Responde estas breves preguntas para personalizar tu experiencia.")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 40)
            
            VStack(alignment: .leading, spacing: 20) {
                if currentStep == 1 {
                    QuestionContentView(
                        question: "¿Cuál es tu objetivo principal?",
                        options: ["💰 Ahorrar más", "📈 Invertir", "💳 Pagar deudas"],
                        selectedAnswer: $answerQ1
                    )
                } else if currentStep == 2 {
                    QuestionContentView(
                        question: "¿Llevas un registro de tus gastos?",
                        options: ["📝 Sí, siempre", "🤔 A veces", "🙈 Nunca"],
                        selectedAnswer: $answerQ2
                    )
                } else if currentStep == 3 {
                    QuestionContentView(
                        question: "¿Cómo te sientes al revisar tus finanzas?",
                        options: ["😰 Ansioso", "😐 Indiferente", "💪 Motivado", "🤔 Confundido"],
                        selectedAnswer: $answerQ3
                    )
                }
            }
            .animation(.easeInOut, value: currentStep)
            
            Spacer()
            
            if currentStep < 3 {
                Button(action: {
                    withAnimation {
                        currentStep += 1
                    }
                }) {
                    Text("Siguiente")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(isCurrentStepAnswered() ? Color.black : Color.gray.opacity(0.4))
                        .cornerRadius(25)
                }
                .disabled(!isCurrentStepAnswered())
                .padding(.bottom, 50)
            } else {
                NavigationLink(destination: AnalyzingProfileView()) {
                    Text("Finalizar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(answerQ3.isEmpty ? Color.gray.opacity(0.4) : Color.black)
                        .cornerRadius(25)
                }
                .disabled(answerQ3.isEmpty)
                .padding(.bottom, 50)
            }
        }
        .padding(.horizontal, 30)
        .navigationBarHidden(true)
    }
    
    func isCurrentStepAnswered() -> Bool {
        if currentStep == 1 { return !answerQ1.isEmpty }
        if currentStep == 2 { return !answerQ2.isEmpty }
        if currentStep == 3 { return !answerQ3.isEmpty }
        return false
    }
}

struct QuestionContentView: View {
    var question: String
    var options: [String]
    @Binding var selectedAnswer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedAnswer = option
                }) {
                    HStack {
                        Text(option)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(selectedAnswer == option ? .black : .primary)
                        Spacer()
                        if selectedAnswer == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.black)
                                .font(.title3)
                        }
                    }
                    .padding()
                    .background(selectedAnswer == option ? Color.gray.opacity(0.1) : Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(selectedAnswer == option ? Color.black : Color.gray.opacity(0.3), lineWidth: selectedAnswer == option ? 2 : 1)
                    )
                }
            }
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
    }
}

struct FinancialProfileView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialProfileView()
    }
}

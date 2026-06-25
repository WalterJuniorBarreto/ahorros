import SwiftUI

struct WelcomeView: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("monthlySavingsGoal") var savingsGoal: Double = 0.0
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    @State private var currentStep = 1
    @State private var nameInput: String = ""
    @State private var goalInput: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack(spacing: 8) {
                Circle()
                    .fill(currentStep == 1 ? Color.black : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(currentStep == 2 ? Color.black : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
                Spacer()
            }
            .padding(.top, 20)
            
            Spacer()
            
            if currentStep == 1 {
                VStack(alignment: .leading, spacing: 15) {
                    Image(systemName: "hand.wave.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                        .padding(.bottom, 10)
                    
                    Text("Comencemos.")
                        .font(.system(size: 40, weight: .bold))
                    
                    Text("¿Cómo te gusta que te llamen?")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    TextField("Tu nombre", text: $nameInput)
                        .font(.system(size: 24, weight: .bold))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.top, 20)
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                
            } else {
                VStack(alignment: .leading, spacing: 15) {
                    Image(systemName: "target")
                        .font(.system(size: 40))
                        .foregroundColor(.mint)
                        .padding(.bottom, 10)
                    
                    Text("Hola, \(nameInput).")
                        .font(.system(size: 40, weight: .bold))
                    
                    Text("¿Cuál es tu meta de ahorro mensual?")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("S/.")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gray)
                        TextField("0.00", text: $goalInput)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 24, weight: .bold))
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.top, 20)
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: handleNext) {
                    Text(currentStep == 1 ? "Siguiente" : "Comenzar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(isInputValid ? Color.black : Color.gray.opacity(0.3))
                        .cornerRadius(20)
                        .shadow(color: isInputValid ? Color.black.opacity(0.2) : Color.clear, radius: 10, x: 0, y: 5)
                }
                .disabled(!isInputValid)
                
                if currentStep == 2 {
                    Button(action: skipGoal) {
                        Text("No tengo ahorros por ahora")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .padding(.vertical, 10)
                    }
                    .transition(.opacity)
                }
            }
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 30)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentStep)
    }
    
    var isInputValid: Bool {
        if currentStep == 1 {
            return !nameInput.trimmingCharacters(in: .whitespaces).isEmpty
        } else {
            return !goalInput.trimmingCharacters(in: .whitespaces).isEmpty && (Double(goalInput) != nil)
        }
    }
    
    func handleNext() {
        if currentStep == 1 {
            currentStep = 2
        } else {
            userName = nameInput
            savingsGoal = Double(goalInput) ?? 0.0
            withAnimation {
                hasSeenOnboarding = true
            }
        }
    }
    
    func skipGoal() {
        userName = nameInput
        savingsGoal = 0.0
        withAnimation {
            hasSeenOnboarding = true
        }
    }
}

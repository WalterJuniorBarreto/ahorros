import SwiftUI

struct SavingGoalView: View {
    @AppStorage("monthlySavingsGoal") var savingsGoal: Double = 0.0
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    @State private var selectedOption: String? = nil
    @State private var customAmount: String = ""
    @State private var navigateToDashboard: Bool = false
    
    let presetAmounts = ["50", "100", "200", "300", "500"]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ProgressView(value: 0.95)
                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                .padding(.top, 10)
                .padding(.bottom, 30)
            
            Text("¿Cuánto quieres ahorrar cada mes?")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 12)
            
            Text("Establece una meta de ahorro realista que puedas cumplir. Podrás cambiarla más adelante.")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 30)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(presetAmounts, id: \.self) { amount in
                    AmountCardView(
                        title: "S/.\(amount)",
                        subtitle: "/mes",
                        isSelected: selectedOption == amount
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedOption = amount
                        }
                    }
                }
                
                AmountCardView(
                    title: "✏️",
                    subtitle: "Otra",
                    isSelected: selectedOption == "custom"
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedOption = "custom"
                    }
                }
            }
            .padding(.bottom, 20)
            
            if selectedOption == "custom" {
                TextField("Ingresa el monto (Ej. 1500)", text: $customAmount)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 20, weight: .semibold))
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1.5)
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            Spacer()
            
            Button(action: {
                saveGoalAndContinue()
            }) {
                Text("Finalizar y comenzar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(isSelectionValid() ? Color.black : Color.gray.opacity(0.4))
                    .cornerRadius(25)
            }
            .disabled(!isSelectionValid())
            .padding(.bottom, 15)
            
            Button(action: {
                skipGoalAndContinue()
            }) {
                Text("No quiero ahorrar por ahora")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30)
            
            NavigationLink(destination: DashboardView(), isActive: $navigateToDashboard) {
                EmptyView()
            }
        }
        .padding(.horizontal, 30)
        .navigationBarHidden(true)
    }
    
    
    func isSelectionValid() -> Bool {
        if selectedOption == "custom" {
            return !customAmount.trimmingCharacters(in: .whitespaces).isEmpty
        }
        return selectedOption != nil
    }
    
    func saveGoalAndContinue() {
            if selectedOption == "custom" {
                savingsGoal = Double(customAmount) ?? 0.0
            } else if let option = selectedOption {
                savingsGoal = Double(option) ?? 0.0
            }
           
            hasSeenOnboarding = true
        }
    
    func skipGoalAndContinue() {
            savingsGoal = 0.0
            hasSeenOnboarding = true 
        }
}

struct AmountCardView: View {
    var title: String
    var subtitle: String
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(isSelected ? .white : .black)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 85)
        .background(isSelected ? Color.black : Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.black : Color.gray.opacity(0.3), lineWidth: isSelected ? 0 : 1)
        )
        .shadow(color: Color.black.opacity(isSelected ? 0.2 : 0.05), radius: 5, x: 0, y: 3)
    }
}

struct SavingGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SavingGoalView()
    }
}

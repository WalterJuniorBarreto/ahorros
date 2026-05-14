import SwiftUI
import SwiftData

struct GoalsListView: View {
    @Query(sort: \SavingGoal.targetDate, order: .forward) private var goals: [SavingGoal]
    @AppStorage("monthlySavingsGoal") var onboardingGoal: Double = 0.0
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    
    @State private var showingAddGoal = false
    @State private var goalToEdit: SavingGoal?
    
    var currentSaved: Double {
        let income = transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
        let expense = transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
        return max(0, income - expense)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Meta Mensual General")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    GoalProgressView(
                        savedAmount: currentSaved,
                        goalAmount: onboardingGoal,
                        customTitle: "Ahorro del Mes",
                        customIcon: "target"
                    )
                    .padding(.horizontal)
                }
                
                Divider().padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Metas Específicas")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    if goals.isEmpty {
                        Text("Aún no tienes metas como 'Viaje' o 'Laptop'. Toca el '+' para crear una.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        ForEach(goals) { goal in
                            Button(action: { goalToEdit = goal }) {
                                GoalCardView(goal: goal)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Mis Metas")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddGoal = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            ManageGoalView()
        }
        .sheet(item: $goalToEdit) { goal in
            ManageGoalView(goalToEdit: goal)
        }
    }
}


struct GoalCardView: View {
    var goal: SavingGoal
    
    var progress: Double {
        if goal.targetAmount <= 0 { return 0 }
        return min(goal.savedAmount / goal.targetAmount, 1.0)
    }
    
    var isMet: Bool { progress >= 1.0 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                ZStack {
                    Circle()
                        .fill(isMet ? Color.green : Color.black)
                        .frame(width: 45, height: 45)
                    Image(systemName: goal.icon)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.title)
                        .font(.headline)
                    Text("Límite: \(goal.targetDate.formatted(.dateTime.day().month().year()))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if isMet {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("S/. \(String(format: "%.2f", goal.savedAmount))")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isMet ? .green : .primary)
                    Spacer()
                    Text("de S/. \(String(format: "%.0f", goal.targetAmount))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: isMet ? .green : .black))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

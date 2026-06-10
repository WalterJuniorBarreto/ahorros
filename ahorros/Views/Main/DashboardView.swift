import SwiftUI
import SwiftData

struct DashboardView: View {
    @AppStorage("userName") var userName: String = "Walter"
    @AppStorage("monthlySavingsGoal") var savingsGoal: Double = 0.0
    
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query(sort: \SavingGoal.targetDate, order: .forward) private var goals: [SavingGoal]
    
    @State private var showingAddTransaction = false
    @State private var transactionToEdit: Transaction?
    
    var monthlyIncome: Double {
        transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
    }
    
    var monthlyExpense: Double {
        transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
    }
    
    var currentBalance: Double {
        monthlyIncome - monthlyExpense
    }
    
    var totalSaved: Double {
        max(0, currentBalance)
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hola, \(userName)")
                                .font(.system(size: 28, weight: .bold))
                            Text("Aquí está tu resumen financiero")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 45))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    
                    BalanceCardView(balance: currentBalance, income: monthlyIncome, expense: monthlyExpense)
                        .padding(.horizontal, 25)

                    NavigationLink(destination: GoalsListView()) {
                        if let firstGoal = goals.first {
                            GoalProgressView(
                                savedAmount: firstGoal.savedAmount,
                                goalAmount: firstGoal.targetAmount,
                                customTitle: firstGoal.title,
                                customIcon: firstGoal.icon
                            )
                        } else {
                            GoalProgressView(savedAmount: totalSaved, goalAmount: savingsGoal)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 25)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Alertas Inteligentes")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal, 25)
                        
                        FinancialHealthCard(income: monthlyIncome, expense: monthlyExpense)
                            .padding(.horizontal, 25)
                        
                        FinancialInsightsView()
                    }
                    .padding(.top, 5)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Últimos movimientos")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            Text("Ver todo")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 25)
                        
                        VStack(spacing: 12) {
                            if transactions.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "tray.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray.opacity(0.3))
                                    Text("Aún no tienes movimientos")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 20)
                            } else {
                                ForEach(transactions.prefix(5)) { transaction in
                                    Button(action: {
                                        transactionToEdit = transaction
                                    }) {
                                        TransactionRowView(transaction: transaction)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTransaction = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                ManageIncomeView()
            }
            .sheet(item: $transactionToEdit) { transaction in
                ManageIncomeView(incomeToEdit: transaction)
            }
        }
    }
}

struct BalanceCardView: View {
    var balance: Double
    var income: Double
    var expense: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Saldo Actual")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Text("S/. \(String(format: "%.2f", balance))")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.white)
            }
            
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.down.left.circle.fill").font(.title2).foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Ingresos").font(.caption).foregroundColor(.white.opacity(0.8))
                        Text("S/. \(String(format: "%.2f", income))").font(.headline).foregroundColor(.white)
                    }
                }
                Spacer()
                HStack(spacing: 10) {
                    Image(systemName: "arrow.up.right.circle.fill").font(.title2).foregroundColor(.red)
                    VStack(alignment: .leading) {
                        Text("Gastos").font(.caption).foregroundColor(.white.opacity(0.8))
                        Text("S/. \(String(format: "%.2f", expense))").font(.headline).foregroundColor(.white)
                    }
                }
            }
        }
        .padding(25)
        .background(Color.black)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 10)
    }
}

struct GoalProgressView: View {
    var savedAmount: Double
    var goalAmount: Double
    var customTitle: String? = nil
    var customIcon: String? = nil
    
    var progress: Double {
        if goalAmount <= 0 { return 0 }
        return min(savedAmount / goalAmount, 1.0)
    }
    
    var isGoalMet: Bool {
        return goalAmount > 0 && savedAmount >= goalAmount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(isGoalMet ? "¡\(customTitle ?? "Meta") Cumplida!" : (customTitle ?? "Meta de Ahorro Activa"))
                        .font(.headline)
                        .foregroundColor(isGoalMet ? .green : .primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(isGoalMet ? "¡Excelente trabajo este mes!" : "Ahorro total vs objetivo")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: isGoalMet ? "star.circle.fill" : (customIcon ?? "target"))
                    .font(.title)
                    .foregroundColor(isGoalMet ? .green : .black)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("S/. \(String(format: "%.2f", savedAmount))")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(isGoalMet ? .green : .primary)
                    Spacer()
                    Text("de S/. \(String(format: "%.0f", goalAmount))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 10)
                        
                        Capsule()
                            .fill(isGoalMet ? Color.green : Color.black)
                            .frame(width: geometry.size.width * CGFloat(progress), height: 10)
                            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: progress)
                    }
                }
                .frame(height: 10)
            }
        }
        .padding(20)
        .background(isGoalMet ? Color.green.opacity(0.05) : Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isGoalMet ? Color.green.opacity(0.5) : Color.gray.opacity(0.2), lineWidth: isGoalMet ? 2 : 1)
        )
    }
}

struct TransactionRowView: View {
    var transaction: Transaction
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color(UIColor.systemGray6))
                    .frame(width: 50, height: 50)
                Image(systemName: getIcon(for: transaction.category))
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.note.isEmpty ? transaction.category : transaction.note)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                Text(transaction.category)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(transaction.isIncome ? "+" : "-")S/. \(String(format: "%.2f", transaction.amount))")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(transaction.isIncome ? .green : .primary)
        }
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
    }
    
    func getIcon(for category: String) -> String {
        switch category.lowercased() {
        case "sueldo": return "briefcase.fill"
        case "alimentación", "comida": return "cart.fill"
        case "suscripciones": return "play.tv.fill"
        case "transporte", "movilidad": return "car.fill"
        case "inversiones": return "chart.line.uptrend.xyaxis"
        default: return "dollarsign.circle.fill"
        }
    }
}

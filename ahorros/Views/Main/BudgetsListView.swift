import SwiftUI
import SwiftData

struct BudgetsListView: View {
    @Query private var budgets: [Budget]
    @Query(filter: #Predicate<Transaction> { $0.isIncome == false }) private var expenses: [Transaction]
    
    @State private var showingAddBudget = false
    
    @State private var budgetToEdit: Budget?
    @State private var selectedCategoryForExpense: String? = nil
    @State private var showingGeneralExpenseWithBudgetRestrictions = false
    
    @State private var selectedBudgetForOptions: Budget?
    @State private var showingOptions = false
    
    var activeBudgetCategories: [String] {
        budgets.map { $0.category }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    if !budgets.isEmpty {
                        Button(action: {
                            showingGeneralExpenseWithBudgetRestrictions = true
                        }) {
                            HStack {
                                Image(systemName: "cart.badge.plus")
                                    .font(.headline)
                                Text("Registrar Gasto de Presupuesto")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    if budgets.isEmpty {
                        VStack(spacing: 15) {
                            Image(systemName: "chart.pie.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.3))
                            Text("Sin presupuestos definidos")
                                .font(.headline)
                            Text("Establece límites para 'Comida' o 'Transporte' para no pasarte este mes.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 50)
                    } else {
                        ForEach(budgets) { budget in
                            Button(action: {
                                selectedBudgetForOptions = budget
                                showingOptions = true
                            }) {
                                BudgetProgressCard(
                                    budget: budget,
                                    spent: calculateSpent(for: budget.category)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Presupuestos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBudget = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                ManageBudgetView()
            }
            .sheet(item: $budgetToEdit) { budget in
                ManageBudgetView(budgetToEdit: budget)
            }
            .sheet(item: $selectedCategoryForExpense) { categoryName in
                ManageIncomeView(preselectedCategory: categoryName)
            }
            .sheet(isPresented: $showingGeneralExpenseWithBudgetRestrictions) {
                ManageIncomeView(limitToBudgetCategories: true, activeBudgetCategories: activeBudgetCategories)
            }
            .confirmationDialog(
                "Opciones",
                isPresented: $showingOptions,
                titleVisibility: .hidden
            ) {
                if let budget = selectedBudgetForOptions {
                    Button("Registrar Gasto en \(budget.category)") {
                        selectedCategoryForExpense = budget.category
                    }
                    
                    Button("Editar o Eliminar Límite") {
                        budgetToEdit = budget
                    }
                    
                    Button("Cancelar", role: .cancel) { }
                }
            } message: {
                if let budget = selectedBudgetForOptions {
                    Text("¿Qué deseas hacer con el presupuesto de \(budget.category)?")
                }
            }
        }
    }
    
    func calculateSpent(for category: String) -> Double {
        let categoryExpenses = expenses.filter { $0.category == category }
        return categoryExpenses.reduce(0) { $0 + $1.amount }
    }
}

extension String: Identifiable {
    public var id: String { self }
}

struct BudgetProgressCard: View {
    var budget: Budget
    var spent: Double
    
    var progress: Double {
        if budget.limitAmount <= 0 { return 0 }
        return min(spent / budget.limitAmount, 1.0)
    }
    
    var isOverBudget: Bool {
        spent >= budget.limitAmount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(budget.category)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                if isOverBudget {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                Text("S/. \(String(format: "%.2f", spent)) gastado")
                    .font(.subheadline)
                    .foregroundColor(isOverBudget ? .red : .primary)
                    .fontWeight(isOverBudget ? .bold : .regular)
                Spacer()
                Text("Límite: S/. \(String(format: "%.0f", budget.limitAmount))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                    
                    Capsule()
                        .fill(isOverBudget ? Color.red : Color.blue)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 12)
                        .animation(.spring(), value: progress)
                }
            }
            .frame(height: 12)
            
            if isOverBudget {
                Text("¡Has superado tu límite mensual!")
                    .font(.caption2)
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isOverBudget ? Color.red.opacity(0.6) : Color.clear, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

import SwiftUI
import SwiftData

struct ManageBudgetView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var budgetToEdit: Budget?
    
    @State private var category: String = "Alimentación"
    @State private var limitAmount: String = ""
    
    let expenseCategories = ["Alimentación", "Transporte", "Suscripciones", "Salud", "Ropa", "Otros"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles del Presupuesto")) {
                    Picker(selection: $category, label: HStack {
                        Image(systemName: "tag.fill").foregroundColor(.blue)
                        Text("Categoría")
                    }) {
                        ForEach(expenseCategories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    
                    HStack {
                        Text("Límite: S/.")
                            .foregroundColor(.gray)
                            .font(.system(size: 20, weight: .bold))
                        TextField("0.00", text: $limitAmount)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                
                Section {
                    Button(action: saveBudget) {
                        Text(budgetToEdit == nil ? "Crear Presupuesto" : "Actualizar Presupuesto")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.black)
                }
                
                if let budget = budgetToEdit {
                    Section {
                        Button(action: { deleteBudget(budget) }) {
                            HStack {
                                Spacer()
                                Image(systemName: "trash.fill")
                                Text("Eliminar Presupuesto")
                                Spacer()
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(budgetToEdit == nil ? "Nuevo Límite" : "Editar Límite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(UIColor.systemGray3))
                    }
                }
            }
            .onAppear {
                if let budget = budgetToEdit {
                    category = budget.category
                    limitAmount = String(budget.limitAmount)
                }
            }
        }
    }
    
    func saveBudget() {
        guard let limit = Double(limitAmount) else { return }
        
        if let budget = budgetToEdit {
            budget.category = category
            budget.limitAmount = limit
        } else {
            let newBudget = Budget(category: category, limitAmount: limit)
            context.insert(newBudget)
        }
        dismiss()
    }
    
    func deleteBudget(_ budget: Budget) {
        context.delete(budget)
        dismiss()
    }
}

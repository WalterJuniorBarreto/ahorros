import SwiftUI
import SwiftData

struct ManageIncomeView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var incomeToEdit: Transaction?
    
    var preselectedCategory: String? = nil
    var limitToBudgetCategories: Bool = false
    var activeBudgetCategories: [String] = []
    
    @State private var amount: String = ""
    @State private var category: String = "Sueldo"
    @State private var date: Date = .now
    @State private var isRecurring: Bool = false
    @State private var note: String = ""
    @State private var isIncomeType: Bool = true
    
    @FocusState private var isInputActive: Bool
    
    let incomeCategories = ["Sueldo", "Negocio", "Inversiones", "Regalo", "Otros"]
    let defaultExpenseCategories = ["Alimentación", "Transporte", "Suscripciones", "Salud", "Ropa", "Otros"]
    
    var dynamicExpenseCategories: [String] {
        if limitToBudgetCategories {
            return activeBudgetCategories.isEmpty ? ["Otros"] : activeBudgetCategories
        }
        return defaultExpenseCategories
    }
    
    var isFormValid: Bool {
        guard let value = Double(amount), value > 0 else { return false }
        return true
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                if preselectedCategory == nil && !limitToBudgetCategories {
                    Section {
                        Picker("Tipo de Movimiento", selection: $isIncomeType) {
                            Text("Ingreso").tag(true)
                            Text("Gasto").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: isIncomeType) { _ in
                            category = isIncomeType ? "Sueldo" : dynamicExpenseCategories.first ?? "Otros"
                        }
                    }
                }
                
                Section(header: Text("Detalles del Movimiento")) {
                    HStack {
                        Text("S/.")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gray)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .focused($isInputActive)
                            .font(.system(size: 24, weight: .bold))
                    }
                    
                    Picker(selection: $category, label: HStack {
                        Image(systemName: "tag.fill").foregroundColor(.blue)
                        Text("Categoría")
                    }) {
                        ForEach(isIncomeType ? incomeCategories : dynamicExpenseCategories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    .disabled(preselectedCategory != nil) 
                    
                    DatePicker(selection: $date, displayedComponents: .date, label: {
                        HStack {
                            Image(systemName: "calendar").foregroundColor(.red)
                            Text("Fecha")
                        }
                    })
                }
                
                Section(header: Text("Opciones Adicionales")) {
                    Toggle(isOn: $isRecurring) {
                        HStack {
                            Image(systemName: "repeat").foregroundColor(.purple)
                            Text("Movimiento Recurrente")
                        }
                    }
                    .tint(.black)
                    
                    HStack {
                        Image(systemName: "pencil.line").foregroundColor(.gray)
                        TextField("Nota o descripción", text: $note)
                    }
                }
                
                Section {
                    Button(action: saveTransaction) {
                        Text(incomeToEdit == nil ? "Guardar Movimiento" : "Actualizar Movimiento")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(isFormValid ? Color.black : Color.gray.opacity(0.4))
                    .disabled(!isFormValid)
                }
                
                if let income = incomeToEdit {
                    Section {
                        Button(action: { deleteTransaction(income) }) {
                            HStack {
                                Spacer()
                                Image(systemName: "trash.fill")
                                Text("Eliminar Movimiento")
                                Spacer()
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(incomeToEdit == nil ? "Nuevo Gasto" : "Editar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(UIColor.systemGray3))
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    Button("Listo") { isInputActive = false }
                }
            }
            .onAppear {
                if let income = incomeToEdit {
                    amount = String(income.amount)
                    category = income.category
                    date = income.date
                    isRecurring = income.isRecurring
                    note = income.note
                    isIncomeType = income.isIncome
                } else if let preCat = preselectedCategory {
                    isIncomeType = false
                    category = preCat
                    isInputActive = true
                } else if limitToBudgetCategories {
                    isIncomeType = false
                    category = dynamicExpenseCategories.first ?? "Otros"
                    isInputActive = true
                } else {
                    isInputActive = true
                }
            }
        }
    }
    
    func saveTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        if let income = incomeToEdit {
            income.amount = amountValue
            income.category = category
            income.date = date
            income.isRecurring = isRecurring
            income.note = note
            income.isIncome = isIncomeType
        } else {
            let newTransaction = Transaction(
                amount: amountValue,
                category: category,
                date: date,
                isIncome: isIncomeType,
                isRecurring: isRecurring,
                note: note
            )
            context.insert(newTransaction)
        }
        dismiss()
    }
    
    func deleteTransaction(_ income: Transaction) {
        context.delete(income)
        dismiss()
    }
}

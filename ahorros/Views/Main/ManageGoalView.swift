import SwiftUI
import SwiftData

struct ManageGoalView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var goalToEdit: SavingGoal?
    
    @State private var title: String = ""
    @State private var targetAmount: String = ""
    @State private var savedAmount: String = "0"
    @State private var targetDate: Date = Date().addingTimeInterval(86400 * 30) // +30 días por defecto
    @State private var icon: String = "star.fill"
    
    let icons = ["star.fill", "car.fill", "airplane", "house.fill", "laptopcomputer", "gamecontroller.fill", "graduationcap.fill"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles de la Meta")) {
                    TextField("Nombre de la meta (Ej. Viaje)", text: $title)
                        .font(.system(size: 20, weight: .semibold))
                    
                    HStack {
                        Text("Objetivo: S/.")
                            .foregroundColor(.gray)
                        TextField("0.00", text: $targetAmount)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .bold))
                    }
                    
                    DatePicker("Fecha límite", selection: $targetDate, displayedComponents: .date)
                }
                
                Section(header: Text("Progreso Actual")) {
                    HStack {
                        Text("Ahorrado: S/.")
                            .foregroundColor(.green)
                        TextField("0.00", text: $savedAmount)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
                
                Section(header: Text("Icono Personalizado")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(icons, id: \.self) { iconName in
                                ZStack {
                                    Circle()
                                        .fill(icon == iconName ? Color.black : Color(UIColor.systemGray6))
                                        .frame(width: 50, height: 50)
                                    Image(systemName: iconName)
                                        .font(.system(size: 20))
                                        .foregroundColor(icon == iconName ? .white : .black)
                                }
                                .onTapGesture {
                                    withAnimation { icon = iconName }
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Section {
                    Button(action: saveGoal) {
                        Text(goalToEdit == nil ? "Crear Meta" : "Actualizar Meta")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.black)
                }
                
                if let goal = goalToEdit {
                    Section {
                        Button(action: { deleteGoal(goal) }) {
                            HStack {
                                Spacer()
                                Image(systemName: "trash.fill")
                                Text("Eliminar Meta")
                                Spacer()
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(goalToEdit == nil ? "Nueva Meta" : "Editar Meta")
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
                if let goal = goalToEdit {
                    title = goal.title
                    targetAmount = String(goal.targetAmount)
                    savedAmount = String(goal.savedAmount)
                    targetDate = goal.targetDate
                    icon = goal.icon
                }
            }
        }
    }
    
    func saveGoal() {
        guard let target = Double(targetAmount), !title.isEmpty else { return }
        let saved = Double(savedAmount) ?? 0.0
        
        if let goal = goalToEdit {
            goal.title = title
            goal.targetAmount = target
            goal.savedAmount = saved
            goal.targetDate = targetDate
            goal.icon = icon
        } else {
            let newGoal = SavingGoal(title: title, targetAmount: target, savedAmount: saved, targetDate: targetDate, icon: icon)
            context.insert(newGoal)
        }
        dismiss()
    }
    
    func deleteGoal(_ goal: SavingGoal) {
        context.delete(goal)
        dismiss()
    }
}

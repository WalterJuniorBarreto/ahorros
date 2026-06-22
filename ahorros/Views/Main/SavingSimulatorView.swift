//
//  SavingSimulatorView.swift
//  ahorros
//
//  Created by Alumno Tecsup on 10/06/26.


import SwiftUI

struct SavingSimulatorView: View {
    @State private var targetAmount: String = ""
    @State private var monthlySavings: String = ""
    
    @FocusState private var isInputActive: Bool

    var calculatedMonths: Int {
        guard let target = Double(targetAmount), let monthly = Double(monthlySavings), monthly > 0 else {
            return 0
        }
        return Int(ceil(target / monthly))
    }

    var estimatedDate: Date {
        return Calendar.current.date(byAdding: .month, value: calculatedMonths, to: Date()) ?? Date()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Meta: S/.")
                            .fontWeight(.bold)
                        TextField("Ej. 5000", text: $targetAmount)
                            .keyboardType(.decimalPad)
                            .focused($isInputActive)
                    }
                    HStack {
                        Text("Ahorro mensual: S/.")
                            .fontWeight(.bold)
                        TextField("Ej. 500", text: $monthlySavings)
                            .keyboardType(.decimalPad)
                            .focused($isInputActive)
                    }
                }

                if calculatedMonths > 0 {
                    Section {
                        VStack(alignment: .center, spacing: 15) {
                            Text("Tiempo estimado")
                                .font(.headline)
                            
                            Text("\(calculatedMonths) meses")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.mint)
                            
                            Text("Lo lograrás en:")
                                .foregroundColor(.gray)
                            
                            Text(estimatedDate.formatted(.dateTime.month(.wide).year()))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationTitle("Simulador")
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Listo") { isInputActive = false }
                }
            }
        }
    }
}

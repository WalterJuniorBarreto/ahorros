import SwiftUI
import SwiftData

struct FinancialCalendarView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @State private var selectedDate: Date = Date()
    @State private var transactionToEdit: Transaction?
    
    var dayTransactions: [Transaction] {
        transactions.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                DatePicker("Seleccionar fecha", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .accentColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding()

                List {
                    Section(header: Text("Movimientos del \(selectedDate.formatted(.dateTime.day().month().year()))")) {
                        if dayTransactions.isEmpty {
                            Text("No hay registros para este día")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .listRowBackground(Color.clear)
                        } else {
                            ForEach(dayTransactions) { transaction in
                                Button(action: {
                                    transactionToEdit = transaction
                                }) {
                                    TransactionRowView(transaction: transaction)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Calendario")
            .sheet(item: $transactionToEdit) { transaction in
                ManageIncomeView(incomeToEdit: transaction)
            }
        }
    }
}//
//  FinancialCalendarView.swift
//  ahorros
//
//  Created by Alumno Tecsup on 10/06/26.
//


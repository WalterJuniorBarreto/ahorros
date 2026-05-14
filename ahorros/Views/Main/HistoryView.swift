import SwiftUI
import SwiftData

// MARK: - Opciones de Filtro y Orden
enum TransactionFilter: String, CaseIterable {
    case all = "Todos"
    case income = "Ingresos"
    case expense = "Gastos"
}

enum TransactionSort: String, CaseIterable {
    case newest = "Más recientes"
    case oldest = "Más antiguos"
    case highest = "Mayor monto"
    case lowest = "Menor monto"
}

struct HistoryView: View {
    @Query private var transactions: [Transaction]
    
    @State private var searchText: String = ""
    @State private var selectedFilter: TransactionFilter = .all
    @State private var selectedSort: TransactionSort = .newest
    
    @State private var transactionToEdit: Transaction?
    
    var filteredAndSortedTransactions: [Transaction] {
        var result = transactions
        switch selectedFilter {
        case .income:
            result = result.filter { $0.isIncome }
        case .expense:
            result = result.filter { !$0.isIncome }
        case .all:
            break
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.category.localizedCaseInsensitiveContains(searchText) ||
                $0.note.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        result.sort { a, b in
            switch selectedSort {
            case .newest: return a.date > b.date
            case .oldest: return a.date < b.date
            case .highest: return a.amount > b.amount
            case .lowest: return a.amount < b.amount
            }
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if transactions.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("No hay movimientos")
                            .font(.headline)
                        Text("Tus ingresos y gastos aparecerán aquí.")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                    Spacer()
                } else {
                    List {
                        Text("\(filteredAndSortedTransactions.count) movimientos encontrados")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        
                        ForEach(filteredAndSortedTransactions) { transaction in
                            Button(action: {
                                transactionToEdit = transaction
                            }) {
                                TransactionRowView(transaction: transaction)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Historial")
            .searchable(text: $searchText, prompt: "Buscar por categoría o nota...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section(header: Text("Filtrar por tipo")) {
                            Picker("Filtro", selection: $selectedFilter) {
                                ForEach(TransactionFilter.allCases, id: \.self) { filter in
                                    Text(filter.rawValue).tag(filter)
                                }
                            }
                        }
                        
                        Section(header: Text("Ordenar por")) {
                            Picker("Orden", selection: $selectedSort) {
                                ForEach(TransactionSort.allCases, id: \.self) { sort in
                                    Text(sort.rawValue).tag(sort)
                                }
                            }
                        }
                    } label: {
                     
                        Image(systemName: selectedFilter == .all && selectedSort == .newest ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(item: $transactionToEdit) { transaction in
                ManageIncomeView(incomeToEdit: transaction)
            }
        }
    }
}

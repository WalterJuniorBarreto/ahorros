import SwiftUI
import SwiftData
import Charts

enum ChartTab: String, CaseIterable {
    case expenses = "Gastos"
    case incomes = "Ingresos"
    case comparison = "Balance"
}

struct ChartData: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
}

struct StatisticsView: View {
    @Query private var transactions: [Transaction]
    @State private var selectedTab: ChartTab = .expenses
    @State private var animateCharts: Bool = false 
    var expensesByCategory: [ChartData] {
        let expenses = transactions.filter { !$0.isIncome }
        let grouped = Dictionary(grouping: expenses, by: { $0.category })
        return grouped.map { ChartData(category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }
    
    var incomesByCategory: [ChartData] {
        let incomes = transactions.filter { $0.isIncome }
        let grouped = Dictionary(grouping: incomes, by: { $0.category })
        return grouped.map { ChartData(category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }
    
    var totalIncome: Double {
        transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpense: Double {
        transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    HStack(spacing: 15) {
                        KPICard(title: "Ingresos", amount: totalIncome, icon: "arrow.down.left", color: .mint)
                        KPICard(title: "Gastos", amount: totalExpense, icon: "arrow.up.right", color: .pink)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Picker("Análisis", selection: $selectedTab) {
                        ForEach(ChartTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .onChange(of: selectedTab) { _ in
                        triggerAnimation()
                    }
                    
                    VStack {
                        if transactions.isEmpty {
                            EmptyDataView()
                        } else {
                            VStack(alignment: .leading, spacing: 15) {
                                Text(selectedTab == .comparison ? "Resumen General" : "Distribución por Categoría")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Group {
                                    switch selectedTab {
                                    case .expenses:
                                        InteractiveBarChart(data: expensesByCategory, isExpense: true, animate: animateCharts)
                                    case .incomes:
                                        InteractiveDonutChart(data: incomesByCategory, animate: animateCharts)
                                    case .comparison:
                                        ComparisonBarChart(income: totalIncome, expense: totalExpense, animate: animateCharts)
                                    }
                                }
                                .frame(minHeight: 280)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.04), radius: 15, x: 0, y: 8)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                }
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Análisis Financiero")
            .onAppear {
                triggerAnimation()
            }
        }
    }
    
    private func triggerAnimation() {
        animateCharts = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateCharts = true
            }
        }
    }
}


struct KPICard: View {
    var title: String
    var amount: Double
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle().fill(color.opacity(0.15)).frame(width: 35, height: 35)
                    Image(systemName: icon).font(.system(size: 14, weight: .bold)).foregroundColor(color)
                }
                Spacer()
                Text(title).font(.subheadline).fontWeight(.semibold).foregroundColor(.gray)
            }
            Text("S/. \(String(format: "%.0f", amount))")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

struct EmptyDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle().fill(Color.gray.opacity(0.1)).frame(width: 80, height: 80)
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 35))
                    .foregroundColor(.gray.opacity(0.5))
            }
            Text("Análisis no disponible")
                .font(.title3).fontWeight(.bold)
            Text("Registra tus primeros movimientos para desbloquear las estadísticas e interacciones.")
                .font(.subheadline).foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 40)
    }
}


struct InteractiveBarChart: View {
    var data: [ChartData]
    var isExpense: Bool
    var animate: Bool
    
    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Monto", animate ? item.amount : 0),
                y: .value("Categoría", item.category)
            )
            .foregroundStyle(isExpense ? Color.pink.gradient : Color.mint.gradient)
            .cornerRadius(6)
            .annotation(position: .trailing, alignment: .leading) {
                Text("S/. \(String(format: "%.0f", item.amount))")
                    .font(.caption).fontWeight(.bold).foregroundColor(.gray)
                    .opacity(animate ? 1 : 0)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisValueLabel()
                    .font(.caption.weight(.medium))
            }
        }
    }
}

struct InteractiveDonutChart: View {
    var data: [ChartData]
    var animate: Bool
    
    var total: Double {
        data.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        ZStack {
            Chart(data) { item in
                SectorMark(
                    angle: .value("Monto", animate ? item.amount : 0),
                    innerRadius: .ratio(0.65),
                    angularInset: 2.5
                )
                .cornerRadius(8)
                .foregroundStyle(by: .value("Categoría", item.category))
            }
            .chartLegend(position: .bottom, spacing: 20)
            
            VStack {
                Text("Total")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("S/.\(String(format: "%.0f", total))")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .opacity(animate ? 1 : 0)
        }
    }
}

struct ComparisonBarChart: View {
    var income: Double
    var expense: Double
    var animate: Bool
    
    let chartColors: [String: Color] = ["Ingresos": .mint, "Gastos": .pink]
    
    var body: some View {
        VStack {
            Chart {
                BarMark(
                    x: .value("Tipo", "Ingresos"),
                    y: .value("Monto", animate ? income : 0)
                )
                .foregroundStyle(Color.mint.gradient)
                .cornerRadius(10)
                
                BarMark(
                    x: .value("Tipo", "Gastos"),
                    y: .value("Monto", animate ? expense : 0)
                )
                .foregroundStyle(Color.pink.gradient)
                .cornerRadius(10)
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel().font(.subheadline.weight(.semibold))
                }
            }
            
            Divider().padding(.vertical, 10)
            
            let net = income - expense
            HStack {
                Text("Flujo de Caja Neto")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(net >= 0 ? "+" : "")S/. \(String(format: "%.2f", net))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(net >= 0 ? .mint : .pink)
            }
            .padding(.horizontal, 5)
        }
    }
}

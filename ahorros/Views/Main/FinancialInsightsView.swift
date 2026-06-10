import SwiftUI
import SwiftData

struct FinancialInsightsView: View {
    @Query private var transactions: [Transaction]

    var insights: [Insight] {
        var generatedInsights: [Insight] = []
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: now)!
        let lastMonthNum = calendar.component(.month, from: lastMonth)

        let currentMonthExpenses = transactions.filter { !$0.isIncome && calendar.component(.month, from: $0.date) == currentMonth }.reduce(0) { $0 + $1.amount }
        let lastMonthExpenses = transactions.filter { !$0.isIncome && calendar.component(.month, from: $0.date) == lastMonthNum }.reduce(0) { $0 + $1.amount }

        if currentMonthExpenses > lastMonthExpenses && lastMonthExpenses > 0 {
            generatedInsights.append(Insight(icon: "chart.line.uptrend.xyaxis", color: .red, title: "Gastos en aumento", message: "Tus gastos aumentaron respecto al mes anterior."))
        }

        let expenses = transactions.filter { !$0.isIncome && calendar.component(.month, from: $0.date) == currentMonth }
        let grouped = Dictionary(grouping: expenses, by: { $0.category })
        if let maxCategory = grouped.max(by: { $0.value.reduce(0) { $0 + $1.amount } < $1.value.reduce(0) { $0 + $1.amount } }) {
            let maxAmount = maxCategory.value.reduce(0) { $0 + $1.amount }
            if maxAmount > (currentMonthExpenses * 0.4) {
                generatedInsights.append(Insight(icon: "exclamationmark.circle.fill", color: .orange, title: "Gasto concentrado", message: "Gastas mucho en \(maxCategory.key)."))
            }
        }

        let currentMonthIncomes = transactions.filter { $0.isIncome && calendar.component(.month, from: $0.date) == currentMonth }.reduce(0) { $0 + $1.amount }
        let potentialSavings = currentMonthIncomes - currentMonthExpenses
        
        if potentialSavings > 0 {
            generatedInsights.append(Insight(icon: "leaf.fill", color: .green, title: "Oportunidad", message: "Podrías ahorrar S/. \(String(format: "%.0f", potentialSavings)) más al mes."))
        }

        if generatedInsights.isEmpty {
            generatedInsights.append(Insight(icon: "checkmark.seal.fill", color: .blue, title: "Todo en orden", message: "Tus finanzas se mantienen estables este mes."))
        }

        return generatedInsights
    }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(insights) { insight in
                InsightCard(insight: insight)
            }
        }
        .padding(.horizontal, 25)
    }
}

struct Insight: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
    let title: String
    let message: String
}

struct InsightCard: View {
    var insight: Insight

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(insight.color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: insight.icon)
                    .font(.title2)
                    .foregroundColor(insight.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(insight.message)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

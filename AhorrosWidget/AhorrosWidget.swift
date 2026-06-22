import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    @MainActor func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), balance: 1250.0)
    }

    @MainActor func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), balance: 1250.0)
        completion(entry)
    }

    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var balance: Double = 0.0
        
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: Transaction.self, Budget.self, SavingGoal.self, configurations: config)
            let descriptor = FetchDescriptor<Transaction>()
            let transactions = try container.mainContext.fetch(descriptor)
            
            let income = transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
            let expense = transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
            balance = income - expense
        } catch {
            balance = 0.0
        }

        let entry = SimpleEntry(date: Date(), balance: balance)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let balance: Double
}

struct AhorrosWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.green)
                Text("Ahorros")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            Text("Saldo Actual")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("S/. \(String(format: "%.2f", entry.balance))")
                .font(.title2)
                .fontWeight(.bold)
                .minimumScaleFactor(0.5)
        }
        .containerBackground(Color.white, for: .widget)
    }
}

@main
struct AhorrosWidget: Widget {
    let kind: String = "AhorrosWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AhorrosWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Resumen Financiero")
        .description("Mira tu saldo actual rápidamente.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}


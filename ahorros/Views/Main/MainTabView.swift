import SwiftUI

struct MainTabView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Resumen", systemImage: "house.fill") }
            
            
            

            
            StatisticsView()
                .tabItem { Label("Análisis", systemImage: "chart.bar.xaxis") }
            
            GoalsListView()
                .tabItem { Label("Metas", systemImage: "target") }
            
            BudgetsListView()
            .tabItem { Label("Presupuestos", systemImage: "chart.pie.fill") }
            
            FinancialCalendarView()
                .tabItem { Label("Calendario", systemImage: "calendar") }
            
            HistoryView()
                .tabItem { Label("Historial", systemImage: "list.bullet.rectangle.portrait.fill") }
            
            SavingSimulatorView()
                            .tabItem { Label("Simulador", systemImage: "wand.and.stars") }
        }
        .tint(.black)
        .onAppear {
            RecurringManager.shared.processRecurringTransactions(context: context)
        }
    }
}

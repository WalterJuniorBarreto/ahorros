import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Resumen", systemImage: "house.fill") }
            
            HistoryView()
                .tabItem { Label("Historial", systemImage: "list.bullet.rectangle.portrait.fill") }
            
            StatisticsView()
                .tabItem { Label("Análisis", systemImage: "chart.bar.xaxis") }
            
            GoalsListView()
                .tabItem { Label("Metas", systemImage: "target") }
            
            BudgetsListView()
                .tabItem { Label("Presupuestos", systemImage: "chart.pie.fill") }
        }
        .tint(.black)
    }
}

import SwiftUI

struct MainView: View {
    var body: some View {
      
        TabView {
            
          
            DashboardView()
                .tabItem {
                    Label("Resumen", systemImage: "house.fill")
                }
        
            GoalsListView()
                .tabItem {
                    Label("Metas", systemImage: "target")
                }
            
          
            BudgetsListView()
                .tabItem {
                    Label("Presupuestos", systemImage: "chart.pie.fill")
                }
        }
        .tint(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

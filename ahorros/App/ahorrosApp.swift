import SwiftUI
import SwiftData

@main
struct ahorrosApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            if appCoordinator.isSplashScreenActive {
                SplashScreenView()
                    .onAppear {
                        appCoordinator.startAppFlow()
                    }
            } else {
                if hasSeenOnboarding {
                    MainTabView()
                } else {
                    WelcomeView()
                }
            }
        }
        .modelContainer(for: [Transaction.self, SavingGoal.self, Budget.self])
    }
}

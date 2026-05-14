import SwiftData
import Foundation

@Model
class SavingGoal {
    var id: UUID
    var title: String
    var targetAmount: Double
    var savedAmount: Double 
    var targetDate: Date
    var icon: String
    
    init(title: String, targetAmount: Double, savedAmount: Double = 0.0, targetDate: Date, icon: String = "target") {
        self.id = UUID()
        self.title = title
        self.targetAmount = targetAmount
        self.savedAmount = savedAmount
        self.targetDate = targetDate
        self.icon = icon
    }
}

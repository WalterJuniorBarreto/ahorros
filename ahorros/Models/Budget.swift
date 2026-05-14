import SwiftData
import Foundation

@Model
class Budget {
    var id: UUID
    var category: String
    var limitAmount: Double
    
    init(category: String, limitAmount: Double) {
        self.id = UUID()
        self.category = category
        self.limitAmount = limitAmount
    }
}

import SwiftData
import Foundation

@Model
class Transaction {
    var id: UUID
    var amount: Double
    var category: String
    var date: Date
    var isIncome: Bool
    var isRecurring: Bool
    var note: String
    
    init(amount: Double, category: String, date: Date = .now, isIncome: Bool = true, isRecurring: Bool = false, note: String = "") {
        self.id = UUID()
        self.amount = amount
        self.category = category
        self.date = date
        self.isIncome = isIncome
        self.isRecurring = isRecurring
        self.note = note
    }
}

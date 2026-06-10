import Foundation
import SwiftData

class RecurringManager {
    static let shared = RecurringManager()
    
    func processRecurringTransactions(context: ModelContext) {
        let descriptor = FetchDescriptor<Transaction>()
        guard let allTransactions = try? context.fetch(descriptor) else { return }
        
        let recurringTemplates = allTransactions.filter { $0.isRecurring }
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        for template in recurringTemplates {
            let templateMonth = calendar.component(.month, from: template.date)
            let templateYear = calendar.component(.year, from: template.date)
            
            if templateYear > currentYear || (templateYear == currentYear && templateMonth >= currentMonth) {
                continue
            }
            
            let alreadyGenerated = allTransactions.contains { tx in
                let txMonth = calendar.component(.month, from: tx.date)
                let txYear = calendar.component(.year, from: tx.date)
                return tx.category == template.category &&
                       tx.note == template.note &&
                       tx.isIncome == template.isIncome &&
                       txMonth == currentMonth &&
                       txYear == currentYear
            }
            
            if !alreadyGenerated {
                let automaticTransaction = Transaction(
                    amount: template.amount,
                    category: template.category,
                    date: Date(),
                    isIncome: template.isIncome,
                    isRecurring: true,
                    note: template.note
                )
                context.insert(automaticTransaction)
            }
        }
        
        try? context.save()
    }
}

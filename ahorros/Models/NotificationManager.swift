import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func scheduleBudgetAlert(category: String) {
        let content = UNMutableNotificationContent()
        content.title = "Límite Excedido"
        content.body = "Has superado tu presupuesto para \(category)."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        UNUserNotificationCenter.current().add(request)
    }

    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Resumen Financiero"
        content.body = "¿Ya registraste tus gastos de hoy? Mantén tus números al día."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}

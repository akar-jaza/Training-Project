import UserNotifications
import UIKit

final class NotificationService {

    private let center = UNUserNotificationCenter.current()

    func authorizationStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()

        return settings.authorizationStatus
    }

    func requestPermission() async throws -> Bool {

        try await center.requestAuthorization(
            options: [.alert, .badge, .sound]
        )
    }

    func openSettings() {

        guard let url = URL(
            string: UIApplication.openNotificationSettingsURLString
        ) else {
            return
        }

        UIApplication.shared.open(url)
    }
}

import Foundation
import UserNotifications
import Combine

@MainActor
final class NotificationPermissionViewModel: ObservableObject {

    @Published private(set) var isEnabled = false

    private let notificationService: NotificationService

    init(
        notificationService: NotificationService? = nil
    ) {
        self.notificationService =
            notificationService ?? NotificationService()
    }

    func refreshStatus() async {
        
        let status =
        await notificationService.authorizationStatus()
        
        let newValue = isNotificationEnabled(status)
        
        if isEnabled != newValue {
            isEnabled = newValue
        }
    }

    func enableNotifications() async {

        let status =
            await notificationService.authorizationStatus()

        switch status {

        case .notDetermined:

            do {
                _ = try await notificationService.requestPermission()

                await refreshStatus()

            } catch {
                print(
                    "Notification permission error:",
                    error
                )
            }

        case .denied:
            notificationService.openSettings()

        case .authorized,
             .provisional,
             .ephemeral:

            isEnabled = true

        @unknown default:
            isEnabled = false
        }
    }

    private func isNotificationEnabled(
        _ status: UNAuthorizationStatus
    ) -> Bool {

        switch status {

        case .authorized,
             .provisional,
             .ephemeral:

            return true

        default:

            return false
        }
    }
}

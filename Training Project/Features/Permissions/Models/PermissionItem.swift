import Foundation

struct PermissionItem: Identifiable {
    let id = UUID()
    let type: PermissionType
    let isEnabled: Bool
}

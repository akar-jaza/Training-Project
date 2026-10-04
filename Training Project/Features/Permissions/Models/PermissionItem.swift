import Foundation

struct PermissionItem: Identifiable {
    var id: PermissionType { type }
    let type: PermissionType
    let isEnabled: Bool
}

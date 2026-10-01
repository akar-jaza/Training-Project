import SwiftUI

enum PermissionType: String {
    
    case location = "Location Services"
    case notifications = "Notifications"
    case camera = "Camera"
    case microphone = "Microphone"
    case photos = "Photos"
    case bluetooth = "Bluetooth"
    case faceID = "Face ID"
    
    var icon: String {
        switch self {
        case .location:
            return "location.fill"
            
        case .notifications:
            return "bell.fill"
            
        case .camera:
            return "camera.fill"
            
        case .microphone:
            return "mic.fill"
            
        case .photos:
            return "photo.fill"
            
        case .bluetooth:
            return "dot.radiowaves.left.and.right"
            
        case .faceID:
            return "faceid"
        }
    }
    
    var color: Color {
        switch self {
        case .location:
            return .blue
            
        case .notifications:
            return .orange
            
        case .camera:
            return .purple
            
        case .microphone:
            return .pink
            
        case .photos:
            return .green
            
        case .bluetooth:
            return .cyan
            
        case .faceID:
            return .indigo
        }
    }
}

struct PermissionsView: View {
    @State private var showLocationSheet = false
    @StateObject private var viewModel =
    LocationPermissionViewModel()
    
    var permissions: [PermissionItem] {
        [
            PermissionItem(
                type: .location,
                isEnabled: viewModel.isEnabled
            ),
            
            PermissionItem(
                type: .notifications,
                isEnabled: false
            ),
            
            PermissionItem(
                type: .camera,
                isEnabled: false
            ),
            
            PermissionItem(
                type: .microphone,
                isEnabled: false
            ),
            
            PermissionItem(
                type: .photos,
                isEnabled: false
            ),
            
            PermissionItem(
                type: .bluetooth,
                isEnabled: false
            ),
            
            PermissionItem(
                type: .faceID,
                isEnabled: false
            )
        ]
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(permissions) { permission in
                    PermissionRow(permission: permission)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if permission.type.rawValue == PermissionType.location.rawValue {
                                showLocationSheet = true
                            }
                        }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Permissions")
            }
        }
        .sheet(isPresented: $showLocationSheet) {
            LocationPermissionSheetView(viewModel: viewModel)
                .presentationDetents([.medium])
        }
    }
    
    
    struct PermissionRow: View {
        
        let permission: PermissionItem
        
        var body: some View {
            HStack(spacing: 14) {
                
                Image(systemName: permission.type.icon)
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 32, height: 32)
                    .foregroundStyle(permission.type.color)
                
                Text(permission.type.rawValue)
                    .font(.body)
                
                Spacer()
                
                Text(permission.isEnabled ? "Enabled" : "Disabled")
                    .font(.caption)
                    .foregroundStyle(
                        permission.isEnabled ? .blue : .red
                    )
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        permission.isEnabled
                        ? Color.blue.opacity(0.10)
                        : Color.red.opacity(0.10)
                    )
                    .clipShape(Capsule())
            }
            .padding(.vertical, 6)
        }
    }
}


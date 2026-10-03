import SwiftUI

// MARK: Xalla Makwan
// Live camera preview needs a real iPhone.
// The Simulator will just show a bright white screen, Just like your future, bright, successful, and way less pixelated, inshallah.
// One day he’ll look back at this comment and laugh, right after he hired me.

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
    @StateObject var locationViewModel =
    LocationPermissionViewModel()
    
    @StateObject var notificationViewModel =
    NotificationPermissionViewModel()
    
    @StateObject private var cameraViewModel =
    CameraPermissionViewModel()
    
    @StateObject private var bleManager = BLEManager()
    
    @StateObject private var faceIDViewModel = FaceIDViewModel()
    
    
    @State private var showCameraSheet = false
    @State private var showLocationSheet = false
    @State private var showNotificationSheet = false
    @State private var showPhotoPickerSheet = false
    @State private var showBluetoothSheet = false
    @State private var showFaceIDSheet = false
    
    var permissions: [PermissionItem] {
        [
            PermissionItem(
                type: .location,
                isEnabled: locationViewModel.isEnabled
            ),
            
            PermissionItem(
                type: .notifications,
                isEnabled: notificationViewModel.isEnabled
            ),
            
            PermissionItem(
                type: .camera,
                isEnabled: cameraViewModel.isEnabled
            ),
            
            PermissionItem(
                type: .photos,
                isEnabled: true
            ),
            
            PermissionItem(
                type: .bluetooth,
                isEnabled: bleManager.isSwitchedon
            ),
            
            PermissionItem(
                type: .faceID,
                isEnabled: faceIDViewModel.isEnrolled
            ),
            
            PermissionItem(
                type: .microphone,
                isEnabled: false
            ),
            
            
        ]
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(permissions) { permission in
                    PermissionRow(permission: permission)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            switch permission.type {
                            case .location:
                                showLocationSheet = true
                            case .notifications:
                                showNotificationSheet = true
                            case .camera:
                                showCameraSheet = true
                            case .photos:
                                showPhotoPickerSheet = true
                            case .bluetooth:
                                showBluetoothSheet = true
                            case .faceID:
                                showFaceIDSheet = true
                            default:
                                break
                            }
                        }
                }
            }
            .padding(.top, 15)
            .listStyle(.insetGrouped)
            .navigationTitle("Permissions")
            .sheet(isPresented: $showLocationSheet) {
                LocationPermissionSheetView(viewModel: locationViewModel)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showNotificationSheet) {
                NotificationPermissionSheetView(viewModel: notificationViewModel)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showPhotoPickerSheet) {
                PhotosSheetView()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showCameraSheet) {
                CameraPermissionSheetView(
                    viewModel: cameraViewModel
                )
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showBluetoothSheet) {
                BluetoothDevicesView(bleManager: bleManager)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showFaceIDSheet) {
                FaceIDVideoSheetView()
                    .presentationDetents([.medium, .large])
            }
            
            .task {
                cameraViewModel.refreshStatus()
                bleManager.refreshStatus()
                faceIDViewModel.refreshStatus()
                await notificationViewModel.refreshStatus()
            }
            
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
                
                Text(
                    permission.type == .microphone
                    ? "Soon"
                    : permission.type == .faceID
                    ? (permission.isEnabled ? "Enrolled" : "Unenrolled")
                    : (permission.isEnabled ? "Enabled" : "Disabled")
                )
                .font(.caption)
                .foregroundStyle(
                    permission.type == .microphone
                    ? .orange
                    : (permission.isEnabled ? .blue : .red)
                )
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    permission.type == .microphone
                    ? Color.orange.opacity(0.10)
                    : (permission.isEnabled
                       ? Color.blue.opacity(0.10)
                       : Color.red.opacity(0.10)
                      )
                )
                .clipShape(Capsule())
            }
            .padding(.vertical, 6)
        }
    }
}

#Preview {
    PermissionsView()
}

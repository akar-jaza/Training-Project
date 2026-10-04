import Foundation
import AVFoundation
import Combine

@MainActor
final class CameraPermissionViewModel: ObservableObject {
    
    @Published private(set) var isEnabled = false
    @Published private(set) var cameraPosition:
    AVCaptureDevice.Position = .back
    
    private let cameraService: CameraService
    
    init(
        cameraService: CameraService? = nil
    ) {
        self.cameraService =
        cameraService ?? CameraService()
    }
    
    func refreshStatus() {
        
        let status = cameraService.authorizationStatus
        
        isEnabled = status == .authorized
    }
    
    
    func enableCamera() async {
        
        switch cameraService.authorizationStatus {
            
        case .notDetermined:
            
            let granted =
            await cameraService.requestPermission()
            
            isEnabled = granted
            
            if granted {
                cameraService.startSession()
            }
            
        case .denied, .restricted:
            
            cameraService.openSettings()
            
        case .authorized:
            
            isEnabled = true
            
            cameraService.startSession()
            
        @unknown default:
            
            isEnabled = false
        }
    }
    
    func startCamera() {
        
        guard isEnabled else {
            return
        }
        
        cameraService.startSession()
    }
    
    func stopCamera() {
        cameraService.stopSession()
    }
    
    func toggleCameraPosition() {
        
        let newPosition: AVCaptureDevice.Position =
        cameraPosition == .back ? .front : .back
        
        cameraPosition = newPosition
        
        cameraService.switchCamera(
            to: newPosition
        )
    }
    
    var captureSession: AVCaptureSession {
        cameraService.captureSession
    }
}

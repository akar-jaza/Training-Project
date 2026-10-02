import AVFoundation
import UIKit

final class CameraService {
    
    private let session = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(
        label: "camera.session.queue"
    )
    
    // Keep track of the current camera input.
    private var videoInput: AVCaptureDeviceInput?
    
    var captureSession: AVCaptureSession {
        session
    }
    
    var authorizationStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func requestPermission() async -> Bool {
        await AVCaptureDevice.requestAccess(for: .video)
    }
    
    func openSettings() {
        guard let url = URL(
            string: UIApplication.openSettingsURLString
        ) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func startSession() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            if !session.isRunning {
                configureSession(position: .back)
                session.startRunning()
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            if session.isRunning {
                session.stopRunning()
            }
        }
    }
    
    private func configureSession(
        position: AVCaptureDevice.Position
    ) {
        
        // Don't configure the session twice.
        guard videoInput == nil else {
            return
        }
        
        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: position
        ) else {
            print("Could not find camera")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(
                device: camera
            )
            
            if session.canAddInput(input) {
                session.addInput(input)
                videoInput = input
            }
            
        } catch {
            print(
                "Camera configuration error:",
                error.localizedDescription
            )
        }
    }
        
    func switchCamera(
        to position: AVCaptureDevice.Position
    ) {
        
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            guard let currentInput = self.videoInput else {
                return
            }
            
            guard let camera = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: position
            ) else {
                print("Could not find requested camera")
                return
            }
            
            do {
                let newInput = try AVCaptureDeviceInput(
                    device: camera
                )
                
                session.beginConfiguration()
                
                session.removeInput(currentInput)
                
                // Add new camera.
                if session.canAddInput(newInput) {
                    
                    session.addInput(newInput)
                    
                    videoInput = newInput
                    
                } else {
                    session.addInput(currentInput)
                }
                
                session.commitConfiguration()
                
            } catch {
                print(
                    "Failed to switch camera:",
                    error.localizedDescription
                )
            }
        }
    }
}

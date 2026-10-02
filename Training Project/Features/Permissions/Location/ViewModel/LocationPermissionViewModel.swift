import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationPermissionViewModel:
    ObservableObject,
    LocationServiceDelegate {
    
    @Published private(set) var isEnabled = false
    
    private let locationService: LocationService
    
    init(locationService: LocationService? = nil) {
        
        self.locationService =
        locationService ?? LocationService()
        
        self.locationService.delegate = self
        
        refreshStatus()
    }
    
    func refreshStatus() {
        
        let servicesEnabled =
        locationService.isLocationServicesEnabled
        
        let authorization =
        locationService.authorizationStatus
        
        isEnabled =
        servicesEnabled &&
        (
            authorization == .authorizedWhenInUse ||
            authorization == .authorizedAlways
        )
    }
    
    func enableLocation() {
        
        switch locationService.authorizationStatus {
            
        case .notDetermined:
            locationService.requestPermission()
            
        case .denied, .restricted:
            locationService.openSettings()
            
        default:
            break
        }
    }
    
    // Called when iOS tells LocationService that the location permission has changed.
    nonisolated func locationServiceDidChangeAuthorization() {
        Task {
            @MainActor [weak self] in
            self?.refreshStatus()
        }
    }
}

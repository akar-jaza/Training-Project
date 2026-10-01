import CoreLocation
import UIKit

protocol LocationServiceDelegate: AnyObject {
    func locationServiceDidChangeAuthorization()
}

final class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        
        manager.delegate = self
    }
    
    var isLocationServicesEnabled: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        manager.authorizationStatus
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func openSettings() {
        guard let url = URL(
            string: UIApplication.openSettingsURLString
        ) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    // Called by Core Location when the authorization status changes.
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        delegate?.locationServiceDidChangeAuthorization()
    }
}

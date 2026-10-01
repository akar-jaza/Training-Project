import UIKit
import SwiftUI
import Combine

final class PermissionsHostingController: UIHostingController<PermissionsView>{
    weak var coordinator: PermissionsCoordinator?
    
    init() {
        super.init(rootView: PermissionsView())
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

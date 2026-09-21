import UIKit
import SwiftUI
import Combine

final class ProfileHostingController: UIHostingController<ProfileView> {
    private let viewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init(rootView: ProfileView(viewModel: viewModel, onLogout: {}))
        rootView.onLogout = { [weak self] in
            self?.handleLogout()
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindNavigationTitle()
    }
    
    // we don't need the title for now but I keep it here for a reference
    private func bindNavigationTitle() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self else { return }
//                self?.title = user?.firstName ?? "Profile"
//                self.title = "Profile"
            }
            .store(in: &cancellables)   // Combine's version of .disposed(by: disposeBag)!!
    }
    
    private func handleLogout() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate else { return }
        sceneDelegate.switchToLogin()
    }
}

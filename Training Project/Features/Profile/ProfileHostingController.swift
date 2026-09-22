import UIKit
import SwiftUI
import Combine

final class ProfileHostingController: UIHostingController<ProfileView>, ProfileViewModelDelegate {
    
    private let viewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init(rootView: ProfileView(viewModel: viewModel))
        viewModel.delegate = self
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        bindNavigationTitle()
    }
    
    // MARK: - Binding the navigation title
    // we don't need the title for now but I keep it here for a reference
    private func bindNavigationTitle() {
        viewModel.$profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self else { return }
//                self?.title = user?.firstName ?? "Profile"
//                self.title = "Profile"
            }
            .store(in: &cancellables)   // Combine's version of .disposed(by: disposeBag)!!
    }
    
    // MARK: - Profile View Model Delegate
    func didTapLogoutButton() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate else { return }
        UserSessionService.shared.clear()
        sceneDelegate.switchToLogin()
    }
}

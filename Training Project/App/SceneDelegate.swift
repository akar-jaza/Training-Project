import UIKit
import RxSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    var loginCoordinator: LoginCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window?.overrideUserInterfaceStyle = .light
        
        window = UIWindow(windowScene: windowScene)
        if UserSessionService.shared.isLoggedIn {
            switchToMain()
        } else {
            switchToLogin()
        }
        window?.makeKeyAndVisible()
    }
    
    func switchToMain() {
        let tabBarController = MainTabBarController()
        coordinator = AppCoordinator(tabBarController: tabBarController)
        coordinator?.start()
        
        setRootViewController(tabBarController)
    }
    
    func switchToLogin() {
        let navController = UINavigationController()
        let loginCoordinator = LoginCoordinator(navigationController: navController)
        self.loginCoordinator = loginCoordinator
        loginCoordinator.start()
        
        setRootViewController(navController)
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        guard let window = window else { return }
        
        if window.rootViewController != nil {
            UIView.transition(
                with: window,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: {
                    window.rootViewController = viewController
                }
            )
        } else {
            window.rootViewController = viewController
        }
    }
}

import UIKit

final class MainTabBarController: UITabBarController {
    
    let homeNavigationController = UINavigationController()
    let profileNavigationController = UINavigationController(rootViewController: ProfileViewController())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 1
        )
        
        UITabBar.appearance().tintColor = AppColors.primaryColor
        
        viewControllers = [homeNavigationController, profileNavigationController]

    }
}

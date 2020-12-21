import UIKit

class TabBarViewController: UITabBarController {

    let secondTabViewController = SecondTabViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [RootViewController(), UINavigationController(rootViewController: secondTabViewController)]
    }
}

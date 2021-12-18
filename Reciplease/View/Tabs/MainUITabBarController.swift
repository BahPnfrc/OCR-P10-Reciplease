import UIKit

class MainUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().backgroundColor = Painting.colorBrown
//        UITabBar.appearance().isTranslucent = false


        let tabBarItems = tabBar.items! as [UITabBarItem]

        let firstTab = tabBarItems[0]
        firstTab.image = nil
        firstTab.title = "Search"

        let secondTab = tabBarItems[1]
        secondTab.image = nil
        secondTab.title = "Favorite"

        UITabBarItem.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.red],
            for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.blue],
            for: .selected)

        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
    }
}

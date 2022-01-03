import UIKit

class MainUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().backgroundColor = Painting.colorBrown
        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(.blue)
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(Painting.colorBrown)

        // set red as selected background color
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: Painting.colorBrown, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)

        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2

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

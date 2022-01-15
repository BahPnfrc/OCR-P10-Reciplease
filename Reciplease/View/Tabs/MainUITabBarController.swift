import UIKit

class MainUITabBarController: UITabBarController {

    let font: (name: String, size: CGFloat) = ("American Typewriter", 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setNavBar()
        setLayout()
    }

    func setTabBar() {
        if #available(iOS 15.0, *) {
            let ItemAppearance = UITabBarItemAppearance()

            ItemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
            ItemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)

            ItemAppearance.normal.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: Painting.colorHalfWhite,
                NSAttributedString.Key.font:UIFont(name: font.name, size: font.size) ?? UIFont.systemFont(ofSize: font.size)]

            ItemAppearance.selected.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: Painting.colorWhite,
                NSAttributedString.Key.font:UIFont(name: font.name, size: font.size)
                    ?? UIFont.systemFont(ofSize: font.size)]

            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance = ItemAppearance
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Painting.colorBrown
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font.name, size: font.size) as Any], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font.name, size: font.size) as Any], for: .selected)
            tabBar.tintColor = Painting.colorWhite
            tabBar.barTintColor = Painting.colorGrey
            tabBar.itemWidth = 30
            tabBar.itemPositioning = .fill
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
            tabBar.backgroundColor = Painting.colorBrown
        }
    }

    func setNavBar() {
        if #available(iOS 15.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont(
                    name: font.name, size: font.size) as Any,
                NSAttributedString.Key.foregroundColor:
                    Painting.colorWhite]
            navBarAppearance.backgroundColor = Painting.colorBrown
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
            UINavigationBar.appearance().standardAppearance = navBarAppearance
        }
    }

    func setLayout() {
        let tabBarItems = tabBar.items! as [UITabBarItem]
        let firstTab = tabBarItems[0]
        firstTab.image = nil
        firstTab.title = "Search"
        let secondTab = tabBarItems[1]
        secondTab.image = nil
        secondTab.title = "Favorite"
    }
}


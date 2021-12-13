import UIKit

class MainUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes(
            [.foregroundColor: Painting.colorHalfWhite],
            for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [.foregroundColor: Painting.colorWhite],
            for: .selected)
    }
}

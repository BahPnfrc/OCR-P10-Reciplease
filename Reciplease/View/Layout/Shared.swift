import Foundation
import UIKit

class Shared {

    static func paintedSystemImage(named systemName: String) -> UIImage? {
        let config = UIImage.SymbolConfiguration(paletteColors: [Painting.colorWhite, Painting.colorWhite, Painting.colorWhite])
        let image = UIImage(systemName: systemName)
        return image?.applyingSymbolConfiguration(config)
    }

    static var yieldImage: UIImage? {
        Shared.paintedSystemImage(named: "hand.thumbsup")
    }

    static var totalTimeImage: UIImage? {
        Shared.paintedSystemImage(named: "timer")
    }

}

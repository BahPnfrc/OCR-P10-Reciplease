import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!

    @IBOutlet weak var topRightCornerView: UIView!

    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var yieldImageView: UIImageView!
    @IBOutlet weak var totalTimeImageView: UIImageView!

    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.purple.cgColor,
            UIColor.cyan.cgColor
        ]
        gradient.locations = [0, 0.25, 1]
        return gradient
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

//        gradient.frame = contentView.bounds
//        contentView.layer.addSublayer(gradient)

        yieldImageView.image = Shared.yieldImage
        totalTimeImageView.image = Shared.totalTimeImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

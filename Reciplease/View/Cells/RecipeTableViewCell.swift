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

    override func awakeFromNib() {
        super.awakeFromNib()

        yieldImageView.image = Shared.yieldImage
        totalTimeImageView.image = Shared.totalTimeImage

        topRightCornerView.layer.cornerRadius = 5
        topRightCornerView.backgroundColor = Painting.colorBrown
        topRightCornerView.layer.borderWidth = 1
        topRightCornerView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        markLabel.textColor = .white
        timerLabel.textColor = .white

        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0),
            UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        gradient.locations = [0.5, 0.8]
        gradient.frame = backgroundImageView.bounds
        backgroundImageView.layer.addSublayer(gradient)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

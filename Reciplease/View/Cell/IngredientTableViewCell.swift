import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var leadingLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

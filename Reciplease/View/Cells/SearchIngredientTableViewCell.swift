import UIKit

class SearchIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var leadingLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        leadingLabel.textColor = Painting.colorWhite
        ingredientLabel.textColor = Painting.colorWhite
        self.backgroundColor = Painting.colorBrown
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

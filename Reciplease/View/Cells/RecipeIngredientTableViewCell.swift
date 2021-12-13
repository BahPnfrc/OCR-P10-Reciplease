//
//  RecipeXXTableViewCell.swift
//  Reciplease
//
//  Created by Genapi on 11/12/2021.
//

import UIKit

class RecipeIngredientTableViewCell: UITableViewCell {

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

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!

    @IBOutlet weak var recipeTableView: UITableView!

    @IBOutlet weak var topRightCornerView: UIView!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!

    @IBOutlet weak var yieldImageView: UIImageView!
    @IBOutlet weak var totalTimeImageView: UIImageView!

    @IBOutlet weak var unknownButton: UIButton!

    var dataSource = [String]()
    var currentRecipe: Recipe?

    func isFavorite() -> Bool {
        guard let recipe = currentRecipe else { return false }
        return CoreDataController.shared.isFavorite(recipe)
    }

    func totalFavorites() -> Int {
        do {
            return try CoreDataController.shared.get().count
        } catch {
            return 0
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let recipe = currentRecipe, let ingredients = recipe.ingredientLines else {
            return
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(toggleFavoriteData))

        self.toggleFavoriteIcon(to: isFavorite())

        self.recipeLabel.text = recipe.label

        self.yieldLabel.text = String(recipe.yield ?? 0)
        self.totalTimeLabel.text = String(recipe.totalTime ?? 0)

        yieldImageView.image = Shared.yieldImage
        totalTimeImageView.image = Shared.totalTimeImage

        dataSource = ingredients
        recipeTableView.reloadData()

    }

    @objc private func toggleFavoriteData() {
        guard let recipe = currentRecipe else { return }
        if isFavorite() {
            toggleFavoriteDataRemove(recipe: recipe)
        } else {
            toggleFavoriteDataSave(recipe: recipe)
        }
    }

    private func toggleFavoriteDataRemove(recipe: Recipe) {
        do {
            try CoreDataController.shared.delete(recipe)
            if !isFavorite() {
                toggleFavoriteIcon(to: false)
                let alert = UIAlertController(
                    title: "Reciplease",
                    message: "This recipe was removed from Favorite",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } catch {
            let alert = UIAlertController(
                title: "Reciplease",
                message: "Something went wrong and this recipe was not removed from Favorite. Try later.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        print("🟢 Total in Favorite : ", self.totalFavorites())
    }

    private func toggleFavoriteDataSave(recipe: Recipe) {
        do {
            try CoreDataController.shared.add(recipe)
            if isFavorite() {
                toggleFavoriteIcon(to: true)
                let alert = UIAlertController(
                    title: "Reciplease",
                    message: "This recipe was saved into Favorite",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } catch {
            let alert = UIAlertController(
                title: "Reciplease",
                message: "Something went wrong and this recipe was not saved into Favorite. Try later.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        print("🟢 Total in Favorite : ", self.totalFavorites())
    }

    func toggleFavoriteIcon(to state: Bool) {
        switch state {
        case true:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Shared.paintedSystemImage(named: "star.fill"), style: .plain, target: self, action: #selector(toggleFavoriteData))
        default:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Shared.paintedSystemImage(named: "star"), style: .plain, target: self, action: #selector(toggleFavoriteData))
        }
    }

}

extension RecipeViewController: UITableViewDelegate {}

extension RecipeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeIngredientTableViewCell") as! RecipeIngredientTableViewCell
        let ingredient = dataSource[indexPath.row]
        cell.ingredientLabel.text = ingredient
        return cell
    }
}

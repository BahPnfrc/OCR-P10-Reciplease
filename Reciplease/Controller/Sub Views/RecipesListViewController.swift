import UIKit

class RecipesListViewController: UIViewController {

    @IBOutlet weak var recipesTableView: UITableView!
    var dataSource = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()

        paint()
        recipesTableView.dataSource = self
        recipesTableView.delegate = self

        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        recipesTableView.register(nib, forCellReuseIdentifier: "recipeTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        recipesTableView.reloadData()
    }

    private func paint() {
        // navigation
        if let nc = navigationController {
            nc.navigationBar.backgroundColor = Painting.colorBrown
            nc.navigationBar.titleTextAttributes = [.foregroundColor: Painting.colorWhite]
            nc.navigationBar.tintColor = Painting.colorWhite
        }
    }
}

extension RecipesListViewController: UITableViewDelegate { }

extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell") as! RecipeTableViewCell
        let recipe = dataSource[indexPath.row]

        cell.titleLabel.text = recipe.label
        cell.ingredientsLabel.text = recipe.ingredientLines?.joined(separator: ", ")
        cell.timerLabel.text = getRecipeTime(from: recipe.totalTime)
        cell.markLabel.text = getRecipeScore(from: recipe.yield)

        NetworkController.shared.getPicture(fromURL: recipe.image) { result in
            switch result {
            case .failure:
                cell.backgroundImageView.image = UIImage()
            case .success(let image):
                cell.backgroundImageView.image = image
            }
        }
        return cell
    }

    private func getRecipeTime(from time: Int64?) -> String {
        guard var time = time else { return "⎯" }
        if time == 0 { return "⎯" }
        if time < 60 { return "\(time)min" }
        var result = 0
        while time >= 60 {
            time -= 60
            result += 1
        }
        return "\(result)h"
    }

    private func getRecipeScore(from score: Int64?) -> String {
        guard let score = score else { return "⎯"}
        var result = Double(score)
        let units = ["", "k", "M", "Md"]
        var index = 0
        while result >= 1000 {
            result /= 1000
            index += 1
        }
        return "\(result.toString(1))\(units[index])"

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = dataSource[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "recipeViewController") as! RecipeViewController

        vc.currentRecipe = recipe
//        vc.modalPresentationStyle = .fullScreen
        vc.title = "Recipe"

        navigationController?.pushViewController(vc, animated: true)
    }
}

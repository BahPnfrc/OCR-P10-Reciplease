import UIKit

class RecipesListViewController: UIViewController {

    @IBOutlet weak var recipesTableView: UITableView!
    var dataSource = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.dataSource = self
        recipesTableView.delegate = self

        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        recipesTableView.register(nib, forCellReuseIdentifier: "recipeTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        recipesTableView.reloadData()
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
        cell.timerLabel.text = String(recipe.totalTime ?? 0)
        cell.markLabel.text = String(recipe.yield ?? 0)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = dataSource[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "recipeViewController") as! RecipeViewController

        vc.currentRecipe = recipe
        vc.modalPresentationStyle = .fullScreen
        vc.title = "Recipe"

        navigationController?.pushViewController(vc, animated: true)
    }
}

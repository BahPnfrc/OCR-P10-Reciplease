import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientsTableView: UITableView!

    var datasource = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = Painting.colorBrown
        navigationController?.navigationBar.tintColor = Painting.colorWhite
    }

    @IBAction func didTapAddButton(_ sender: Any) {
        guard let ingredient = ingredientsTextField.text?.trimmingCharacters(in: .whitespaces), ingredient.count > 0 else {
            return
        }
        let alert = UIAlertController(title: "New ingredient", message: "Shall we add '\(ingredient)' to the recipe ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "For sure", style: .default) { _ in
            self.datasource.append(ingredient)
            self.ingredientsTableView.reloadData()
            self.ingredientsTextField.text = nil
            self.ingredientsTextField.becomeFirstResponder()
        })
        alert.addAction(UIAlertAction(title: "Nah", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func didTapClearButton(_ sender: Any) {
        guard datasource.count > 0 else { return }
        let alert = UIAlertController(title: "Clear all", message: "Shall we clear it all ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "My mistake", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Definitly", style: .destructive, handler: { _ in
            self.datasource.removeAll()
            self.ingredientsTableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func didTapSearchButton(_ sender: Any) {

        #if targetEnvironment(simulator)
        if datasource.count == 0 {
            guard let fileURL = Bundle.main.url(forResource: "TestRecipeData", withExtension: "json"),
                  let string = try? String(contentsOf: fileURL),
                  let data = string.data(using: .utf8),
                  let result = try? JSONDecoder().decode(RecipeData.self, from: Data(data)) else {
                      return
                  }
            if let recipes: [Recipe] = (result.hits?.compactMap {
                hit -> Recipe? in
                return hit.recipe
            }) {
                showResults(of: recipes)
            }
            return
        }
        #endif

        guard datasource.count > 0 else { return }
        NetworkController.shared.getRecipes(madeWith: datasource) { result in
            switch result {
            case .failure(let error):
                print("🔴 KO")
                print(error)
            case .success(let recipes):
                print("🟢 OK : \(recipes.count) recipe(s)")
                self.showResults(of: recipes)
            }
        }
    }

    private func showResults(of recipes: [Recipe]) {
        guard recipes.count > 0 else {
            let alert = UIAlertController(title: "Recipe", message: "No recipe at all matched this ingredients", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Let me check", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Let me clear", style: .destructive, handler: { _ in
                self.datasource.removeAll()
                self.ingredientsTableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "recipesListViewController") as! RecipesListViewController
        vc.dataSource = recipes

        vc.modalPresentationStyle = .fullScreen
        vc.title = "Results"
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension SearchViewController: UITableViewDelegate {}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchIngredientTableViewCell") as! SearchIngredientTableViewCell
        cell.ingredientLabel.text = datasource[indexPath.row]
        return cell
    }

}

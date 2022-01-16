import UIKit

class RecipesListViewController: GlobalViewController {

    @IBOutlet weak var recipesTableView: UITableView!
    var dataSource = [Recipe]()
    var nextRecipesRequest: String?

    override func viewDidLoad() {
        super.viewDidLoad()

//      paint()
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
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = Painting.colorBrown
                nc.navigationBar.standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            } else {
                nc.navigationBar.backgroundColor = Painting.colorBrown
                nc.navigationBar.tintColor = Painting.colorWhite
            }
            nc.navigationBar.titleTextAttributes = [.foregroundColor: Painting.colorWhite]

            self.navigationController?.navigationBar.tintColor = Painting.colorWhite
        }
    }
}

extension RecipesListViewController: UITableViewDelegate {}

extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell") as! RecipeTableViewCell
        let recipe = dataSource[indexPath.row]

        cell.titleLabel.text = recipe.label
        cell.ingredientsLabel.text = recipe.ingredientLines?.joined(separator: ", ")
        cell.timerLabel.text = recipe.getTime()
        cell.markLabel.text = recipe.getScore()

        RecipeSession.shared.getPicture(fromURL: recipe.image) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure:
                cell.backgroundImageView.image = UIImage()
            case .success(let image):
                cell.backgroundImageView.image = image
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = dataSource[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "recipeViewController") as! RecipeViewController

        vc.currentRecipe = recipe
        vc.title = "Recipe"
        navigationController?.pushViewController(vc, animated: true)
    }

    private func isLastCell(indexPath: IndexPath) -> Bool {
        let isLastCell = indexPath.row == dataSource.count - 1
        return isLastCell
    }

    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLastCell(indexPath: indexPath) {
            guard RecipeSession.shared.nextHref != nil else {
                return
            }
            loadNextRecipes()
        }
    }

    private func loadNextRecipes() -> Void {
        isRequesting = true
        RecipeSession.shared.getNextRecipes() { [weak self] result in
            self?.isRequesting = false
            guard let self = self else { return }

            switch result{
            case .failure(let error):
                print(error)
            case .success(let recipes):
                recipes.forEach({ self.dataSource.append($0) })
                self.recipesTableView.reloadData()
            }
        }
    }
}

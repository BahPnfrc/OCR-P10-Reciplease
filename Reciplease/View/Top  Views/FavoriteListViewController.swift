import UIKit

class FavoriteListViewController: RecipesListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadFavorite()
        super.viewWillAppear(true)
    }

    private func loadFavorite() {
        do {
            dataSource = try CoreDataController.shared.get()
        } catch {
            let alert = UIAlertController(
                title: "Reciplease",
                message: "No favorite Recipe was saved",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

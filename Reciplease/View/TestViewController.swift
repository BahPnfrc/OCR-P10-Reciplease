//
//  TestViewController.swift
//  Reciplease
//
//  Created by Genapi on 06/12/2021.
//

import UIKit
import Alamofire

class TestViewController: UIViewController {

    @IBOutlet weak var contentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let x = ["chicken","okra"]
        RecipeService.getRecipes(madeWith: x) { result in
            print(result)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
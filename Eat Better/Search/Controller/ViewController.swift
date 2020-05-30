//
//  ViewController.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 5/18/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit
import ANActivityIndicator

class ViewController: UIViewController {
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var apiClient = ApiClient()
    var recipes = [Recipe]()
    
    var indicator = ANActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let dimmingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //      self.navigationController?.title = "Your Title"

        resultTableView.delegate = self
        resultTableView.dataSource = self
 
        resultTableView.isHidden = true
    
        prepareForLoading()
        setDoneButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.tabBarController?.title = "Recipe search"
    }

    func prepareForLoading() {
        dimmingView.backgroundColor = .black
        dimmingView.frame = view.frame
        dimmingView.alpha = 0.7
        let side = CGFloat(50)
        indicator = ANActivityIndicatorView.init(frame:
                                                CGRect(x: view.center.x - side/2,
                                                y: view.center.y - side/2,
                                                width: side, height: side),
                                                animationType: .ballClipRotateMultiple)
        indicator.startAnimating()
    }


    @IBAction func additionalSettingButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchSettingsStoryboard", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SearchSettingsViewController") as? SearchSettingsViewController
        self.navigationController?.pushViewController(settingsViewController ?? self, animated: true)
    }

    func getSearchResults () {
        let url = NetworkManager.prepareForSearch(ingredientsTextView.text)
        NetworkManager.searchRecipes (urlString: url) { data in
            self.apiClient.fetchRecipes(data) { recipesArray in
                self.recipes = recipesArray
                if self.recipes.count > 0 {
                    self.resultTableView.reloadData()
                    self.resultTableView.isHidden = false
                }
                else {
                    self.resultTableView.isHidden = true
                    let alert = UIAlertController(title: "Ooops", message: "No recipes were found.", preferredStyle: UIAlertController.Style.alert)
                     alert.addAction(UIAlertAction(title: "OK :(", style: UIAlertAction.Style.default, handler: nil))
                     self.present(alert, animated: true, completion: nil)
                }
                self.settingsButton.isEnabled = true
                self.indicator.removeFromSuperview()
                self.dimmingView.removeFromSuperview()
                
      //          print (self.recipes)
            }
        }
    }

    @IBAction func searchButtonClicked(_ sender: Any) {
        getSearchResults ()
        DispatchQueue.main.async {
            self.view.addSubview(self.dimmingView)
            self.view.addSubview(self.indicator)
            self.view.endEditing(true)
            self.settingsButton.isEnabled = false
        }
    }
    
    
    func setDoneButton() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        ingredientsTextView.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        ingredientsTextView.endEditing(true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as? SearchResultTableViewCell
        cell?.name.text = recipes[indexPath.row].name

        NetworkManager.loadImage ( recipes[indexPath.row].image) { img in
            DispatchQueue.main.async {
                cell?.img.image = img
            }
        }
        cell?.selectionStyle = .none
        return cell ?? SearchResultTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "RecipeStoryboard", bundle: nil)
        let recipeViewController = storyboard.instantiateViewController(withIdentifier: "RecipeViewController") as? RecipeViewController
        recipeViewController?.recipe = recipes[indexPath.row]
        self.navigationController?.pushViewController(recipeViewController ?? self, animated: true)
    }
}

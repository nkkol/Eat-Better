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
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var settingsButton: UIButton!

    var apiClient = ApiClient()
    var recipes = [Recipe]()
    
    var indicator = ANActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let dimmingView = UIView()
    
    var restored = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.delegate = self
        resultTableView.dataSource = self
 
        resultTableView.isHidden = true
    
        prepareForLoading()
        setDoneButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = "Recipe search"
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
        let url = NetworkManager.prepareForSearch(ingredientsTextField.text ?? "")
        NetworkManager.searchRecipes (urlString: url) { result in
            switch result {
            case .success (let data):
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

                }
            case .failure (let error):
               self.resultTableView.isHidden = true
               let alert = UIAlertController(title: "Ooops", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                     alert.addAction(UIAlertAction(title: "OK :(", style: UIAlertAction.Style.default, handler: nil))
                     self.present(alert, animated: true, completion: nil)
            }
            self.settingsButton.isEnabled = true
            self.indicator.removeFromSuperview()
            self.dimmingView.removeFromSuperview()
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
        ingredientsTextField.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        ingredientsTextField.endEditing(true)
    }
    
    // MARK: - State Restoration
    
    private static let encodingIngredientsText = "encodingIngredientsText"
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(self.ingredientsTextField.text, forKey: ViewController.encodingIngredientsText)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        ingredientsTextField.text = coder.decodeObject(forKey: ViewController.encodingIngredientsText) as? String ?? "empty"
        restored = coder.decodeObject(forKey: ViewController.encodingIngredientsText) as? String ?? "empty"
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        super.applicationFinishedRestoringState()
        print("Finished restoring state")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as? SearchResultTableViewCell
        cell?.img.image = UIImage()
        cell?.name.text = recipes[indexPath.row].name
        cell?.setupActivityIndicator()
        NetworkManager.loadImage ( recipes[indexPath.row].image) { img in
            DispatchQueue.main.async {
                cell?.img.image = img
                cell?.activityIndicator.removeFromSuperview()
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let save = saveAction(at: indexPath)
        save.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [save])
    }
    
    func saveAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Save") {(action, view, completion) in
            if !DBManager.share.isSaved(recipe: self.recipes[indexPath.row]) {
                DBManager.share.saveRecipe(recipe: self.recipes[indexPath.row])
            }
           completion(true)
           }
        return action
       }
}


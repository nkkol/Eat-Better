//
//  RecipeViewController.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 25.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit
import WebKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    var recipe = Recipe(name: "Default",
                        image: "Default",
                        source: "Default",
                        urlString: "Default",
                        ingredients: ["Default"],
                        calories: 0.0,
                        weight: 0.0, nutrients: [Nutrient(label: "Default", quantity: 0.0, unit: "Default", fromDaily: nil)])
    
    let block = (UINib(nibName: "View", bundle: nil).instantiate(withOwner: self, options: nil).first as? RecipeView)
    let nutrientsBlock = (UINib(nibName: "NutrientsView", bundle: nil).instantiate(withOwner: self, options: nil).first as? NutrientsView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setBlocks()
        setButton()


    }
    
    func setBlocks() {
        NetworkManager.loadImage ( recipe.image) { img in
            DispatchQueue.main.async {
                self.block?.imageView.image = img
            }
        }
        block?.weightLabel.text = "Weight: " + String(format: "%.2f", recipe.weight) + " g"
        block?.caloriesLabel.text = "Calories: " + String(format: "%.2f", recipe.calories) + " kcal"
        var ingedientString = "Ingredients:\n"
        recipe.ingredients.forEach { (ing) in
            ingedientString += ing + "\n"
        }
        block?.ingredientsLabel.text = ingedientString
        block?.saveButton.addTarget(self, action: #selector(saveARecipe), for: .touchUpInside)
        if DBManager.share.isSaved(recipe: recipe) {
            block?.saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        stackView.addArrangedSubview(block ?? UIView())
        
        nutrientsBlock?.nutrientsCollectionView.delegate  = self
        nutrientsBlock?.nutrientsCollectionView.dataSource = self
        
        stackView.addArrangedSubview(nutrientsBlock ?? UIView())
    }
    
    @objc func saveARecipe() {
        var found = false
        DBManager.share.savedRecipes?.forEach({ saved in
            if saved.name == recipe.name && saved.image == recipe.image && saved.urlString == recipe.urlString {
                DBManager.share.delete(recipe: saved)
                block?.saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                found = true
            }
        })
        if !found {
            DBManager.share.saveRecipe(recipe: recipe)
            block?.saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }
    
    func setButton() {
        let cookingButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        cookingButton.setTitle("Okay, how to cook it?", for: .normal)
        cookingButton.setTitleColor(.systemBlue, for: .normal)
        cookingButton.addTarget(self, action: #selector(findMore), for: .touchUpInside)
        stackView.addArrangedSubview(cookingButton)
    }
    
    @objc func findMore() {
        let url = NSURL(string: recipe.urlString)!
        UIApplication.shared.open(url as URL)
    }
    
    func setTitle() {
        let titlelabel = UILabel()
        titlelabel.text = recipe.name
        titlelabel.textColor = .label
        titlelabel.font = UIFont.boldSystemFont(ofSize: 25)
        titlelabel.backgroundColor = .clear
        titlelabel.adjustsFontSizeToFitWidth = true
        titlelabel.textAlignment = .center
        self.navigationItem.titleView = titlelabel
    }
    
    
}
extension RecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipe.nutrients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        //force
        let cell : CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.nameLabel.text = recipe.nutrients[indexPath.row].label
        cell.quantityUnitLabel.text = String(format: "%.2f", recipe.nutrients[indexPath.row].quantity) + " " + recipe.nutrients[indexPath.row].unit
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = .systemOrange
        }
        else {
            cell.backgroundColor = .systemGreen
        }
        return cell
    }
}

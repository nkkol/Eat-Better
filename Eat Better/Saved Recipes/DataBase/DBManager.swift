//
//  DBManager.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 31.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation
import CoreData

class DBManager {
    
    static var share = DBManager()
    let manageContext = appDelegate?.persistentContainer.viewContext
    
    var savedRecipes: [SavedRecipe]? {
        get {
            return getData()
        }
    }
    
    func getData() -> [SavedRecipe]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedRecipe")
        do {
            return try manageContext?.fetch(request) as? [SavedRecipe]
        } catch {
            print("Error when getting data")
            return nil
        }
    }
    
    func saveRecipe(recipe: Recipe) {
        guard let manageContext = manageContext else { return }
        let savedRecipe = SavedRecipe(context: manageContext)
        savedRecipe.name = recipe.name
        savedRecipe.weight = recipe.weight
        savedRecipe.calories = recipe.calories
        savedRecipe.image = recipe.image
        savedRecipe.urlString = recipe.urlString
        var ingedientString = ""
        recipe.ingredients.forEach { (ing) in
                   ingedientString += ing + "\n"
        }
        savedRecipe.ingredients = ingedientString
        saveContext()
    }
    
    private func saveContext() {
        do {
            try manageContext?.save()
        } catch {
            print("Error when saving manageContext")
        }
    }
    
    func delete(recipe: SavedRecipe) {
        manageContext?.delete(recipe)
        saveContext()
    }
    
    func isSaved(recipe: Recipe)->Bool {
        var found = false
        savedRecipes?.forEach({ saved in
            if saved.name == recipe.name && saved.image == recipe.image && saved.urlString == recipe.urlString {
                found = true
            }
        })
        return found
    }
    /*
    func recipeFromSaved(savedRecipe: SavedRecipe) -> Recipe {
        let recipe = Recipe(name: <#String#>, image: <#String#>, source: <#String#>, urlString: <#String#>, ingredients: <#[String]#>, calories: <#Double#>, weight: <#Double#>, nutrients: <#[Nutrient]#>)
        return recipe
    }*/
}

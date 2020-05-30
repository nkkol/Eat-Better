//
//  SearchSettingsData.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 5/21/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

class SearchSettingsDataManager {
    
    //json them!
    static var healthLabelsDetails = [
        "Alcohol-free" : "No alcohol used or contained",
        "Peanut-free" : "No peanuts or products containing peanuts",
        "Sugar-conscious" : "Less than 4g of sugar per serving",
        "Tree-Nut-free" : "No tree nuts or products containing tree nuts",
        "Vegan" : "No meat, poultry, fish, dairy, eggs or honey",
        "Vegetarian" : "No meat, poultry, or fish",
    ]
    
    static var sortedHealthLabelsDetails = {
        healthLabelsDetails.sorted(by: <)
    }
    
    static var dietLabelsDetails = [
        "Balanced" : "Protein/Fat/Carb values in 15/35/50 ratio",
        "High-Protein" : "More than 50% of total calories from proteins",
        "Low-Carb" : "Less than 20% of total calories from carbs",
        "Low-Fat" : "Less than 15% of total calories from fat",
    ]
    
    static var sortedDietLabelsDetails = {
        dietLabelsDetails.sorted(by: <)
    }
    
    static var selectedHealthLabels = [String:Bool]()
    static var selectedDietLabels = [String:Bool]()
    
    static var firstRun = true
    
    static func firstFill() {
        if firstRun {
            SearchSettingsDataManager.healthLabelsDetails.keys.forEach { label in
                SearchSettingsDataManager.selectedHealthLabels[label] = false
            }
            SearchSettingsDataManager.dietLabelsDetails.keys.forEach { label in
                SearchSettingsDataManager.selectedDietLabels[label] = false
            }
        }
        firstRun = false
    }
    
    static var calories = String()
    
}

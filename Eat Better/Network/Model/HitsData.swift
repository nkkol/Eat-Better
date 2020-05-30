//
//  HitData.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 24.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

class HitsData: Decodable {

    var label : String
    var image : String
    var source : String
    var calories : Double
    var totalWeight : Double
    var url : String
    var ingredientLines = [String]()
    
    var nutrients = [Nutrient]()
    
    enum CodingKeys: String, CodingKey {
        case recipe
    }
    
    enum RecipeCodingKeys: String, CodingKey {
        case label
        case image
        case source
        case url
        case ingredientLines
        case calories
        case totalWeight
        case totalNutrients
    }
    
    enum NutrientsList: String, CodingKey, CaseIterable {
        case ENERC_KCAL
        case FAT
        case FASAT
        case FATRN
        case FAMS
        case FAPU
        case CHOCDF
        case FIBTG
        case SUGAR
        case PROCNT
        case CHOLE
        case NA
        case CA
        case MG
        case K
        case FE
        case ZN
        case P
        case VITA_RAE
        case VITC
        case THIA
        case RIBF
        case NIA
        case VITB6A
        case FOLDFE
        case FOLAC
        case VITB12
        case VITD
        case TOCPHA
        case VITK1
        case WATER
        
    }
    
    enum NutrientsCodingKeys: String, CodingKey {
        case label
        case quantity
        case unit
    }
    
    required init (from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let recipeContainer = try container.nestedContainer(keyedBy: RecipeCodingKeys.self, forKey: .recipe)
    self.label = try recipeContainer.decode(String.self, forKey: .label)
    self.image = try recipeContainer.decode(String.self, forKey: .image)
    self.url = try recipeContainer.decode(String.self, forKey: .url)
    self.calories = try recipeContainer.decode(Double.self, forKey: .calories)
    self.totalWeight = try recipeContainer.decode(Double.self, forKey: .totalWeight)
    self.source = try recipeContainer.decode(String.self, forKey: .source)
    self.ingredientLines = try recipeContainer.decode([String].self, forKey: .ingredientLines)
    let nutrientsListContainer = try recipeContainer.nestedContainer(keyedBy: NutrientsList.self, forKey: .totalNutrients)

    for singleCase in NutrientsList.allCases {
        do {
            let currentContainer = try nutrientsListContainer.nestedContainer(keyedBy: NutrientsCodingKeys.self, forKey: singleCase)
            let label = try currentContainer.decode(String.self, forKey: .label)
            let quantity = try currentContainer.decode(Double.self, forKey: .quantity)
            let unit = try currentContainer.decode(String.self, forKey: .unit)
            nutrients.append(Nutrient(label: label, quantity: quantity, unit: unit, fromDaily: nil))
        }
        catch{}
    }
        
    }

}



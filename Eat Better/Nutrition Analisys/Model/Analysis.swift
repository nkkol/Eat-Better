//
//  Analysis.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 27.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

struct Analysis: Decodable {
    var calories: Double
    var weight: Double
    var nutrients = [Nutrient]()
    
    enum CodingKeys: String, CodingKey {
        case calories
        case totalWeight
        case totalNutrients
        case totalDaily
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
    
    enum NutrientsDailyCodingKeys: String, CodingKey {
        case quantity
    }

     
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.calories = try container.decode(Double.self, forKey: .calories)
        self.weight = try container.decode(Double.self, forKey: .totalWeight)
        let nutrientsListContainer = try container.nestedContainer(keyedBy: NutrientsList.self, forKey: .totalNutrients)
         let nutrientsDailyContainer = try container.nestedContainer(keyedBy: NutrientsList.self, forKey: .totalDaily)
       for singleCase in NutrientsList.allCases {
            do {
                let currentContainer = try nutrientsListContainer.nestedContainer(keyedBy: NutrientsCodingKeys.self, forKey: singleCase)
                let label = try currentContainer.decode(String.self, forKey: .label)
                let quantity = try currentContainer.decode(Double.self, forKey: .quantity)
                let unit = try currentContainer.decode(String.self, forKey: .unit)
                let currentDailyContainer = try nutrientsDailyContainer.nestedContainer(keyedBy: NutrientsDailyCodingKeys.self, forKey: singleCase)
                let fromDaily = try currentDailyContainer.decode(Double.self, forKey: .quantity)
                nutrients.append(Nutrient(label: label, quantity: quantity, unit: unit, fromDaily: fromDaily))
            }
            catch{}
        }
    }
}

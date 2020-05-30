//
//  Recipe.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 23.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

struct Recipe {
    
    var name: String
    var image: String
    var source: String
    var urlString: String
    var ingredients: [String]
    var calories: Double
    var weight: Double

    var nutrients: [Nutrient]
}

    

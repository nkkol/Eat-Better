//
//  Nutrient.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 26.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

struct Nutrient {
    var label: String
    var quantity: Double
    var unit: String
    
    var fromDaily: Optional<Double>
}

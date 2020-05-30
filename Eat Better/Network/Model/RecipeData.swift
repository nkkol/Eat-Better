//
//  RecipeData.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 24.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

class RecipeData: Decodable {
    
    var hits  = [HitsData]()
    
    enum CodingKeys: String, CodingKey {
        case hits
    }
    
    required init (from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
       self.hits = try container.decode([HitsData].self, forKey: .hits)
   }
}

//
//  ApiClient.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 24.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

struct ApiClient {
    
    var hits  = [HitsData]()
    
    mutating func fetchRecipes (_ json: Data, completion: @escaping ([Recipe]) -> Void) {
      let info = try? JSONDecoder().decode(RecipeData.self, from: json)
        hits = info?.hits ?? []
        var recipes = [Recipe]()
        hits.forEach { hit in
            recipes.append(Recipe(name: hit.label,
                                  image: hit.image,
                                  source: hit.source,
                                  urlString: hit.url,
                                  ingredients: hit.ingredientLines,
                                  calories: hit.calories,
                                  weight: hit.totalWeight, nutrients: hit.nutrients))
        }
        print (recipes)
        completion(recipes)
    }
    
    mutating func fetchAnalysis (_ json: Data, completion: @escaping (Analysis) -> Void) {
      let gotAnalysis = try? JSONDecoder().decode(Analysis.self, from: json)
  //      var analysis = gotAnalysis
        print (gotAnalysis)
        //force
        completion(gotAnalysis!)
    }
 
}

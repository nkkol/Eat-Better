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
        print (gotAnalysis as Any)
        //force
        completion(gotAnalysis!)
    }
    
    func fetchLabelsFromMock(isHealth : Bool) -> Labels {
        guard let file = Bundle.main.path(forResource: isHealth ? "HealthLabelsMock" : "DietLabelsMock", ofType: "json"),
        let data = try? Data(contentsOf: URL (fileURLWithPath: file), options: []),
            let labels = try? JSONDecoder().decode(Labels.self, from: data)
            else {return [:] as! Labels}
            print(labels)
        return labels
    }

 
}

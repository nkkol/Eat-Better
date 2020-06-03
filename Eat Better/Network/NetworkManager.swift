//
//  NetworkService.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 23.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static func searchRecipes (urlString: URL, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        AF.request(urlString).response { response in
            switch response.result {
            case .success(let data):
                print("Got data successfully: ", data!)
                completion (.success(response.data!))
            case .failure(let error):
                print("Error while getting data:" + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    static func loadImage (_ urlString : String, completion: @escaping (UIImage) -> Void) {
        AF.request(urlString).response { response in
            guard let responseData = response.data else {return}
            completion(UIImage(data: responseData) ?? UIImage())
        }
    }
    
    
   static func prepareForSearch(_ qValue: String) -> URL {
        var components = URLComponents(string: "https://api.edamam.com/search?")
        components?.queryItems = [ URLQueryItem(name: "app_id", value: "7938416e"), URLQueryItem(name: "app_key", value: "aa3011404d3aba2f7419a40625a37a29"), URLQueryItem(name: "q", value: qValue)]
        SearchSettingsDataManager.selectedHealthLabels.forEach { label in
            if label.value == true {
                components?.queryItems?.append(URLQueryItem(name: "health", value: label.key.lowercased()))
            }
        }
        
        SearchSettingsDataManager.selectedDietLabels.forEach { label in
            if label.value == true {
                components?.queryItems?.append(URLQueryItem(name: "diet", value: label.key.lowercased()))
            }
        }
        
        if SearchSettingsDataManager.calories != "" {
            components?.queryItems?.append(URLQueryItem(name: "calories", value: SearchSettingsDataManager.calories))
        }
    return components?.url ?? URL(string: "Not today")!
    }
    
    static func prepareForAnalyze(_ ingredients: String) -> URL {
        var components = URLComponents(string: "https://api.edamam.com/api/nutrition-data?")
        components?.queryItems = [ URLQueryItem(name: "app_id", value: "78f69e50"), URLQueryItem(name: "app_key", value: "96a355c730f9c3659f59eeedac12db8c"), URLQueryItem(name: "ingr", value: ingredients)]
        return components?.url ?? URL(string: "Not today")!
       }
    
    static func getAnalisys (urlString: URL, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
            AF.request(urlString).response { response in
                switch response.result {
                case .success(let data):
                    print("Got data successfully: ", data!)
                    completion (.success(response.data!))
                case .failure(let error):
                    print("Error while getting data:" + error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
}

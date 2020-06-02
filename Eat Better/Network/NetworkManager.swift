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
    
    static func searchRecipes (urlString: URL, completion: @escaping (Data) -> Void) {
        AF.request(urlString).response { response in
            print(urlString)
            //uncommment and make beauty
            
            
/*            //validate?
            guard let statusCode = response.response?.statusCode else {return}
            print(statusCode)
                       
            if (200..<300).contains(statusCode) {
                let value = response.value
                var api = ApiClient()
                //force
                api.fetch(response.data!)
                //force
                print(value!!)
            }
            else {
                let error = response.error
                print(error ?? "error")
                
                
            }
 */
            print(response.request)
            //force
            completion (response.data!)
            
        }
    }
    
    static func loadImage (_ urlString : String, completion: @escaping (UIImage) -> Void) {
        //force
        AF.request(urlString).response { response in
            completion(UIImage(data: response.data!)!)
        }
    }
    
    
   static func prepareForSearch(_ qValue: String) -> URL {
        
        //force
        var components = URLComponents(string: "https://api.edamam.com/search?")!
        components.queryItems = [ URLQueryItem(name: "app_id", value: "7938416e"), URLQueryItem(name: "app_key", value: "aa3011404d3aba2f7419a40625a37a29"), URLQueryItem(name: "q", value: qValue)]
    
        SearchSettingsDataManager.selectedHealthLabels.forEach { label in
            if label.value == true {
                components.queryItems?.append(URLQueryItem(name: "health", value: label.key.lowercased()))
            }
        }
        
        SearchSettingsDataManager.selectedDietLabels.forEach { label in
            if label.value == true {
                components.queryItems?.append(URLQueryItem(name: "diet", value: label.key.lowercased()))
            }
        }
        
        if SearchSettingsDataManager.calories != "" {
             components.queryItems?.append(URLQueryItem(name: "calories", value: SearchSettingsDataManager.calories))
        }
    //force
        let url = components.url!
        print(url)
        return url
    }
    
    static func prepareForAnalyze(_ ingredients: String) -> URL {

           //force
           var components = URLComponents(string: "https://api.edamam.com/api/nutrition-data?")!
           components.queryItems = [ URLQueryItem(name: "app_id", value: "78f69e50"), URLQueryItem(name: "app_key", value: "96a355c730f9c3659f59eeedac12db8c"), URLQueryItem(name: "ingr", value: ingredients)]
       //force
           let url = components.url!
           print(url)
           return url
       }
    
    static func getAnalisys (urlString: URL, completion: @escaping (Data) -> Void) {
            AF.request(urlString).response { response in
                print(urlString)
                //uncommment and make beauty
                
                
    /*            //validate?
                guard let statusCode = response.response?.statusCode else {return}
                print(statusCode)
                           
                if (200..<300).contains(statusCode) {
                    let value = response.value
                    var api = ApiClient()
                    //force
                    api.fetch(response.data!)
                    //force
                    print(value!!)
                }
                else {
                    let error = response.error
                    print(error ?? "error")
                    
                    
                }
     */
                print(response.request)
                //force
                completion (response.data!)
                
            }
        }
}

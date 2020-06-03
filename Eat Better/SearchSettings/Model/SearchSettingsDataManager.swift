//
//  SearchSettingsData.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 5/21/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

class SearchSettingsDataManager {
    static let apiClient = ApiClient()
    static var healthLabelsDetails = { () -> [String : String] in
        var dictionary = [String : String]()
        let labelsArray = apiClient.fetchLabelsFromMock(isHealth: true)
        labelsArray.labels.forEach { item in
            dictionary[item.label] = item.description
        }
        return dictionary
    }()
    
    static var sortedHealthLabelsDetails = {
        healthLabelsDetails.sorted(by: <)
    }
    
    static var dietLabelsDetails = { () -> [String : String] in
        var dictionary = [String : String]()
        let labelsArray = apiClient.fetchLabelsFromMock(isHealth: false)
        labelsArray.labels.forEach { item in
            dictionary[item.label] = item.description
        }
        return dictionary
    }()
    
    static var sortedDietLabelsDetails = {
        dietLabelsDetails.sorted(by: <)
    }
    
    static var dietLabels: () = {
        let labelsArray = apiClient.fetchLabelsFromMock(isHealth: false)
        labelsArray.labels.forEach { item in
            dietLabelsDetails[item.label] = item.description
        }
        return
    }()
    
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

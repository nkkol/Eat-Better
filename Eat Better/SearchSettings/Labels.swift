//
//  Labels.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 03.06.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation
 
struct Labels: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case labels
    }
    
    let labels: [SettingsLabel]
}

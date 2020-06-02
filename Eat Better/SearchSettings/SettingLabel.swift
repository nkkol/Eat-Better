//
//  HealthLabel.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 03.06.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

struct SettingsLabel: Decodable{
    var label: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case label
        case description
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try container.decode(String.self, forKey: .label)
        self.description = try container.decode(String.self, forKey: .description)
    }
}

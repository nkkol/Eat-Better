//
//  SearchResultTableViewCell.swift
//  Eat Better
//
//  Created by Inna Litvinenko on 24.05.2020.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

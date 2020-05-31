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
    let activityIndicator = UIActivityIndicatorView()
    
    func setupActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
          activityIndicator.centerXAnchor.constraint(equalTo: img.centerXAnchor),
          activityIndicator.centerYAnchor.constraint(equalTo: img.centerYAnchor)
        ])
    }
    
}

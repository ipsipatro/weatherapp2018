//
//  FavouriteCitiesTableViewCell.swift
//  WeatherApp
//
//  Created by Ipsi Patro on 11/03/2018.
//  Copyright © 2018 Ipsi Patro. All rights reserved.
//

import UIKit

class FavouriteCitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    var weather: Weather? {
        didSet {
            guard let weather = weather else{
                return
            }
            cityNameLabel.text = weather.cityName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

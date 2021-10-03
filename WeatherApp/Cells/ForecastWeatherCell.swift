//
//  ForecastWeatherCell.swift
//  WeatherApp
//
//  Created by pro2017 on 02/10/2021.
//

import UIKit

class ForecastWeatherCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var avrTempLabel: UILabel!
    
    static let identifier: String = "ForecastWeatherCell"

    static func nib() -> UINib {
        return UINib(nibName: "ForecastWeatherCell", bundle: nil)
    }
    
    
}

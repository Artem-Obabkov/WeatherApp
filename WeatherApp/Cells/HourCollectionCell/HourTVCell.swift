//
//  HourTVCell.swift
//  WeatherApp
//
//  Created by pro2017 on 28/09/2021.
//

import UIKit

class HourTVCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Register Xib
    
    static let identifier = "HourTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourTVCell", bundle: nil)
    }
    
}

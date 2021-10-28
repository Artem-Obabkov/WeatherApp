//
//  OtherExtensions.swift
//  WeatherApp
//
//  Created by pro2017 on 29/09/2021.
//

import Foundation
import UIKit

extension String {
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
}

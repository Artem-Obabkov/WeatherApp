//
//  MainViewExtension.swift
//  WeatherApp
//
//  Created by pro2017 on 25/09/2021.
//

import Foundation
import UIKit

extension MainView {
    
    func setUpDesign() {
        self.searchButton.layer.cornerRadius = 25
        self.locationButton.layer.cornerRadius = 25
    }
    
    func createAlert(with title: String, message: String?, style: UIAlertController.Style) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.overrideUserInterfaceStyle = .dark
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

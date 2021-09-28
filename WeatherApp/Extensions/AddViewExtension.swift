//
//  AddViewExtension.swift
//  WeatherApp
//
//  Created by pro2017 on 27/09/2021.
//

import Foundation
import UIKit

extension AddView {
    
    // Design
    
    func setupDesign() {
        
        self.cancelButton.layer.cornerRadius = 16
        self.findButton.layer.cornerRadius = 16
        
        self.addView.layer.cornerRadius = 24
        self.addView.layer.borderWidth = 0.3
        self.addView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.addView.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.addView.layer.shadowOpacity = 0.15
        self.addView.layer.shadowRadius = 7
        
        self.textField.attributedPlaceholder = NSAttributedString(string: "City...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
    }
    
    // Alert
    
    func createAlert(with title: String, message: String?, style: UIAlertController.Style) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        alert.overrideUserInterfaceStyle = .dark
        
        let okAction = UIAlertAction(title: "OK", style: .default)
    
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


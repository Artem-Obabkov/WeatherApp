//
//  AddView.swift
//  WeatherApp
//
//  Created by pro2017 on 26/09/2021.
//

import UIKit

class AddView: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    
    var cityName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design
        setupDesign()
        
    }
    
    
    // Actions
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findAction(_ sender: UIButton) {
        
        
        if let tfText  = textField.text, tfText != "" {
            
            let finalText = tfText.trimmingCharacters(in: .whitespaces).lowercased().capitalizeFirstLetter()
            self.cityName = finalText
            
            performSegue(withIdentifier: "findCity", sender: self)
        } else {
            
            createAlert(with: "Whopops...", message: "Seems like you don't type anything", style: .alert)
        }
        
        
    }
 
}

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
        
        self.tableView.backgroundColor = UIColor.clear
        
        // Additional separator at the top of UITableView
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 1 / UIScreen.main.scale))
        topLine.backgroundColor = self.tableView.separatorColor
        self.tableView.tableHeaderView = topLine
        
        // Remove footer separator in table view
        let bottomLine = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 1 / UIScreen.main.scale))
        bottomLine.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = bottomLine
    }
    
    func createAlert(with title: String, message: String?, style: UIAlertController.Style) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.overrideUserInterfaceStyle = .dark
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

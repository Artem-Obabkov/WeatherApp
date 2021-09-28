//
//  MainView.swift
//  WeatherApp
//
//  Created by pro2017 on 25/09/2021.
//

import UIKit

class MainView: UIViewController {
    
    // Weather Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feelsLikeTemp: UILabel!
    
    // Buttons Outlets
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Location
    
    var weatherModels = [Weather]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design
        setUpDesign()
        
        // Cells
        
        tableView.register(HourTVCell.nib(), forCellReuseIdentifier: HourTVCell.identifier)
        tableView.register(WeatherTVCell.nib(), forCellReuseIdentifier: WeatherTVCell.identifier)

    }
    
    // Button Actions
    @IBAction func searchAction(_ sender: UIButton) {
    }
    
    @IBAction func locationAction(_ sender: UIButton) {
    }
    
    // Unwind Segue from AddView
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        guard segue.identifier == "findCity" else { return }
        
        let addVC = segue.source as! AddView
        
        let city = addVC.cityName
        self.locationLabel.text = city
    }
    
}

// TableView

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

// Location Manager



struct Weather {
    
}


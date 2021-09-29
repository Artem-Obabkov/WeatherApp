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
    
    
    // Manager
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design
        setUpDesign()
        
        //networkManager.fetchCurrentWeather(for: "Moscow")
        
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
        
        
        // Если название города состоит из 2 и более слов, то мы соединяем их.
        let cityName = addVC.cityName
        let cityInfo = cityName.split(separator: " ").joined(separator: "%20")
        
        
        // Получаем данные для определенного города
        let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
        userInitiatedQueue.async {
            self.networkManager.fetchCurrentWeather(for: cityInfo)
        }
        // Проверяем есть ли в базе данных такой город и если нет устанавливаем значение по умолчанию
        NetworkManager.errorGroup.notify(queue: .main) { [unowned self] in
            self.createAlert(with: "Whoops...", message: "There is no such city", style: .alert)
            self.locationLabel.text = "City"
        }
        
        
        // Присвоить locationLabel значение JSON name 
        self.locationLabel.text = cityName
        
    }
    
}



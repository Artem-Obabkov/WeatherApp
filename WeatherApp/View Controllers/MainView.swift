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
        
        networkManager.delegate = self
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
            
            // Получаем данные о погоде в выбранном городе
            self.networkManager.fetchCurrentWeather(for: cityInfo)
        }
    }
}

extension MainView: NetworkManagerDelegate {
    
    func updatingInterface(_: NetworkManager, with currentWeather: CurrentWeather) {
        
        DispatchQueue.main.sync {
            self.locationLabel.text = currentWeather.cityName
        }
    }
}

//
//  MainView.swift
//  WeatherApp
//
//  Created by pro2017 on 25/09/2021.
//

import UIKit
import CoreLocation

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
    
    // Managers
    let networkManager = NetworkManager()
    lazy var locationManager: CLLocationManager =  {
        let  lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    // Queues
    let userInitiatedQueue = DispatchQueue.global(qos: .userInteractive)
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        
        networkManager.delegate = self
        
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestLocation()
        }
        
    }
    
    // Button Actions
    
    // Peforming segue
    @IBAction func searchAction(_ sender: UIButton) {
    }
    
    @IBAction func locationAction(_ sender: UIButton) {
        
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestLocation()
        }
        
        
    }
    
    // Unwind Segue from AddView
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        guard segue.identifier == "findCity" else { return }
        
        let addVC = segue.source as! AddView
        
        // Если название города состоит из 2 и более слов, то мы соединяем их.
        let cityName = addVC.cityName
        let cityInfo = cityName.split(separator: " ").joined(separator: "%20")
        
        
        // Получаем данные для определенного города
        userInitiatedQueue.sync {
            
            // Получаем данные о погоде в выбранном городе
            self.networkManager.fetchCurrentWeather(forRequestType: .cityName(city: cityInfo))
        }
    }
}


// MARK: - NetworkManagerDelegate

extension MainView: NetworkManagerDelegate {
    
    func updatingInterface(_: NetworkManager, with currentWeather: CurrentWeather) {
        updateIntefaceWith(weather: currentWeather)
    }
    
    func updateIntefaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.locationLabel.text = weather.cityName
            self.temp.text = weather.temperatureString
            self.feelsLikeTemp.text = "Feels like \(weather.feelsLikeTempString) °C"
            self.weatherImage.image = UIImage(systemName: weather.weatherIconString)
        }
    }
}


// MARK: - CoreLocationDelegate

extension MainView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        
        networkManager.fetchCurrentWeather(forRequestType: .coordinates(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        self.createAlert(with: "Whoops...", message: "Turn on location on your device", style: .alert)
    }
}

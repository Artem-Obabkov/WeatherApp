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
    @IBOutlet weak var tableView: UITableView!
    
    // Buttons Outlets
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    // Managers
    let networkWeatherManager = NetworkWeatherManager()
    lazy var locationManager: CLLocationManager =  {
        let  lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    // Queues
    let userInitiatedQueue = DispatchQueue.global(qos: .userInteractive)
    
    // Weather array
    
    var forecastArray = [ForecastCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        
        networkWeatherManager.delegate = self
        
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestLocation()
            }
        }
        
        // Register NIB
        self.tableView.register(ForecastWeatherCell.nib(), forCellReuseIdentifier: ForecastWeatherCell.identifier)
    }
    
    // Button Actions
    
    // Peforming segue
    @IBAction func searchAction(_ sender: UIButton) {
    }
    
    @IBAction func locationAction(_ sender: UIButton) {
        
        userInitiatedQueue.sync {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestLocation()
            }
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
            self.networkWeatherManager.fetchWeather(forRequestType: .cityName(city: cityInfo))
        }
        
        

    }
}

// MARK: - Table View

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.isEmpty ? 0 : forecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastWeatherCell.identifier) as! ForecastWeatherCell
        
        let dayInfo = forecastArray[indexPath.row]
        
        // Создаем image и устанавливаем contentMode
        let image = UIImage(systemName: dayInfo.weatherImage)
        
        // Присваиваем cell данные полученные из модели ForecastWeather
        cell.weatherImage.image = image
        cell.dateLabel.text = dayInfo.date
        cell.dayLabel.text = dayInfo.day
        cell.maxTempLabel.text = dayInfo.maxTemp
        cell.minTempLabel.text = dayInfo.minTemp
        cell.avrTempLabel.text = dayInfo.avrTemp
        
        return cell
    }
    
}

// MARK: - NetworkManagerDelegate

extension MainView: NetworkWeatherManagerDelegate {
    
    func updatingInterfaceWithForecastWeather(_: NetworkWeatherManager, with forecastWeather: ForecastWeather) {
        
        forecastArray = forecastWeather.getForecastArray()
        
        // Переходим на основную очередб для обноаления интерфейса
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            UIView.transition(with: self.tableView, duration: 0.25, options: .transitionCrossDissolve) {
                
                
                self.tableView.reloadData()
            }
            
            self.updateIntefaceWith(weather: forecastWeather)
        }
        
    }
    
    func updateIntefaceWith(weather: ForecastWeather) {
        
        self.locationLabel.text = weather.cityName
        self.temp.text = weather.tempString
        self.feelsLikeTemp.text = "Feels like \(weather.feelslikeString) °C"
        self.weatherImage.image = UIImage(systemName: weather.getCurrentImageString)
        
        animateIntarface()
    }
    
    func animateIntarface() {
        
        self.locationLabel.layer.opacity = 0.4
        self.temp.layer.opacity = 0.4
        self.feelsLikeTemp.layer.opacity = 0.4
        self.weatherImage.layer.opacity = 0.4
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: .curveEaseInOut) {
            self.locationLabel.layer.opacity = 1
            self.temp.layer.opacity = 1
            self.feelsLikeTemp.layer.opacity = 1
            self.weatherImage.layer.opacity = 1
        }

    }
}


// MARK: - CoreLocationDelegate

extension MainView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchWeather(forRequestType: .coordinates(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        self.createAlert(with: "Whoops...", message: "Turn on location on your device", style: .alert)
    }
}

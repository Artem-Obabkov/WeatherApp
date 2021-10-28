//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by pro2017 on 28/09/2021.
//

import Foundation
import CoreLocation

protocol NetworkWeatherManagerDelegate: class {
    func updatingInterfaceWithForecastWeather(_: NetworkWeatherManager, with forecastWeather: ForecastWeather)
}


class NetworkWeatherManager {
    
    weak var delegate: NetworkWeatherManagerDelegate?
    
    enum RequestType {
        
        case cityName(city: String)
        case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    func fetchWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKeyWeatherApi)&q=\(city)&days=3"
            
            
        case .coordinates(let latitude, let longitude):
            urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKeyWeatherApi)&q=\(latitude),\(longitude)&days=3"
        }
        
        performWeatherTask(with: urlString)
    }
    
    // MARK: - Requests
    
    fileprivate func performWeatherTask(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Все дальнейшее взаимодействее с API будет происходить через сессию
        let session = URLSession(configuration: .default)
        
        // Создаем запрос данных
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                
                // После того как мы получили данные в модель CurrentWeatherData мы должны передать их оттуда в новую модель, с помощью которой мы будем осуществлять обновление интерфейса.
                
                if let forecastWeather = self.parseJSON(with: data) {
                    self.delegate?.updatingInterfaceWithForecastWeather(self, with: forecastWeather)
                    
                }
            }
        }
        task.resume()
    }
    
    // Раскладываем полученные JSON данные по модели которую мы создали CurrentWeatherData
    func parseJSON(with data: Data) -> ForecastWeather? {
        
        // Что бы перевести данные из JSONData в нашу можель мы должны создать JSONDecoder
        let decoder = JSONDecoder()
        
        do {
            // Мы раскодировали данные из JSONData и передаем их в CurrentWeatherData. Эта структура подписана под Codable протокол.
            let forecastWeatherData = try decoder.decode(ForecastWeatherData.self, from: data)
            
            // Создаем модель CurrentWeather что бы в нее передать данные CurrentWeatherData
            guard let forecastWeather = ForecastWeather(forecastWeatherData: forecastWeatherData) else { return nil}
            
            // Возвращаем currentWeather
            return forecastWeather
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
}

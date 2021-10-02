//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by pro2017 on 28/09/2021.
//

import Foundation
import CoreLocation

protocol NetworkWeatherManagerDelegate: class {
    func updatingInterface(_: NetworkWeatherManager, with currentWeather: CurrentWeather)
}


class NetworkWeatherManager {
    
    weak var delegate: NetworkWeatherManagerDelegate?
    
    enum RequestType {
        case cityNameCurrentWeather(city: String)
        case coordinatesCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
        case cityNameForecastWeather(city: String)
        case coordinatesForecastWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    func fetchWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        var isCurrentWeather: Bool = false
        
        switch requestType {
        case .cityNameCurrentWeather(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKeyOpenWeatherMap)&units=metric"
            isCurrentWeather = true
            
        case .coordinatesCurrentWeather(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKeyOpenWeatherMap)&units=metric"
            isCurrentWeather = true
            
        case .cityNameForecastWeather(let city):
            urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKeyWeatherApi)&q=\(city)&days=3"
            isCurrentWeather = false
            
        case .coordinatesForecastWeather(let latitude, let longitude):
            urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKeyWeatherApi)&q=\(latitude),\(longitude)&days=3"
            isCurrentWeather = false
        }
        
        
        performCurrentWeatherTask(with: urlString, isCurrentWeather: isCurrentWeather)
    }
    
    // MARK: - OpenWeatherMap - CurrentWeather
    
    fileprivate func performCurrentWeatherTask(with urlString: String, isCurrentWeather: Bool) {
        guard let url = URL(string: urlString) else { return }
        
        // Все дальнейшее взаимодействее с API будет происходить через сессию
        let session = URLSession(configuration: .default)
        
        // Создаем запрос данных
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                
                // После того как мы получили данные в модель CurrentWeatherData мы должны передать их оттуда в новую модель, с помощью которой мы будем осуществлять обновление интерфейса. С помощью isCurrentWeather мы определяем это запрос по текущей погоде или по прогнозу. 
                if isCurrentWeather {
                    
                    if let currentWeather = self.parseJSON(withData: data) {
                        
                        // Передаем делегате currentWeather что бы потом NetworkManager смог обновить интерфейс
                        self.delegate?.updatingInterface(self, with: currentWeather)
                    }
                } else {
                    self.parseForecastJSON(with: data)
                        
                }
            }
        }
        task.resume()
    }
    
    // Раскладываем полученные JSON данные по модели которую мы создали CurrentWeatherData
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        
        // Что бы перевести данные из JSONData в нашу можель мы должны создать JSONDecoder
        let decoder = JSONDecoder()
        
        do {
            
            // Мы раскодировали данные из JSONData и передаем их в CurrentWeatherData. Эта структура подписана под Codable протокол.
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            
            // Создаем модель CurrentWeather что бы в нее передать данные CurrentWeatherData
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            
            // Возвращаем currentWeather
            return currentWeather
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // MARK: - WeatherApi - Forecast
    
    func parseForecastJSON(with data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let forecastWeatherData = try decoder.decode(ForecastWeatherData.self, from: data)
            
            // TODO: - передать в структуру forecastWeather данные.
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by pro2017 on 28/09/2021.
//

import Foundation
import CoreLocation

protocol NetworkManagerDelegate: class {
    func updatingInterface(_: NetworkManager, with currentWeather: CurrentWeather)
}


class NetworkManager {

    weak var delegate: NetworkManagerDelegate?
    
    enum RequestType {
        case cityName(city: String)
        case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    // TODO: - Create one method from these two
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinates(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        
        performTask(with: urlString)
    }
    
    
    fileprivate func performTask(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Все дальнейшее взаимодействее с API будет происходить через сессию
        let session = URLSession(configuration: .default)
        
        // Создаем запрос данных
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                
                // После того как мы получили данные в модель CurrentWeatherData мы должны передать их оттуда в новую модель, с помощью которой мы будем осуществлять обновление интерфейса
                
                if let currentWeather = self.parseJSON(withData: data) {
                    
                    // Передаем делегате currentWeather что бы потом NetworkManager смог обновить интерфейс
                    self.delegate?.updatingInterface(self, with: currentWeather)
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
}

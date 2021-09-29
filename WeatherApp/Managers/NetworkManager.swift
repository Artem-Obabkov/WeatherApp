//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by pro2017 on 28/09/2021.
//

import Foundation


struct NetworkManager {
    
    static let errorGroup = DispatchGroup()
    
    func fetchCurrentWeather(for city: String) {
        // Recieve data
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            NetworkManager.errorGroup.enter()
            NetworkManager.errorGroup.leave()
            return
            
        }
        
        // Все дальнейшее взаимодействее с API будет происходить через сессию
        let session = URLSession(configuration: .default)
        
        // Создаем запрос данных 
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                self.parseJSON(withData: data)
            }
        }
        
        task.resume()
    }
    
    // Раскладываем полученные JSON данные по модели которую мы создали CurrentWeatherData
    func parseJSON(withData data: Data) {
        
        // Что бы перевести данные из JSONData в нашу можель мы должны создать JSONDecoder
        let decoder = JSONDecoder()
        
        // Мы раскодировали данные из JSONData и передаем их в CurrentWeatherData. Эта структура подписана под Codable протокол.
        do {
            
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
}

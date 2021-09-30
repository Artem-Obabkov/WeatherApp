//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by pro2017 on 29/09/2021.
//

import Foundation

struct CurrentWeather {
    
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        if temperature > 9.9 || temperature < -9.9 {
            return String(format: "%.0f", temperature.rounded())
        }
        return String(format: "%.1f", temperature)
    }
    
    let feelsLikeTemp: Double
    var feelsLikeTempString: String {
        return String(format: "%.1f", feelsLikeTemp)
    }
    
    // В зависимотси от id будет присвоена определенная иконка.
    let conditionCode: Int
    var weatherIconString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "snow"
        case 701...781: return "cloud.fog"
        case 800: return "sun.max"
        case 801: return "cloud.sun"
        case 802: return "cloud"
        case 803...804: return "smoke"
        default: return "nosign"
        }
    }
    
    // Создаем инициализатор, который если что-то пойдет не так возвращает nil
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemp = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}

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
        return "\(temperature.rounded())"
    }
    
    let feelsLikeTemp: Double
    var feelsLikeTempString: String {
        return "\(feelsLikeTemp.rounded())"
    }
    
    let conditionCode: Int
    
    // Должен быть True
    //let isCityAvailable: Bool
    
    // Создаем инициализатор, который если что-то пойдет не так возвращает nil
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemp = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}

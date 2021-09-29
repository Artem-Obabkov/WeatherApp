//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by pro2017 on 29/09/2021.
//

import Foundation

// Мы получили JSON и разложили его по полочкам с помощью сайта QuickType.io Используем только те свойства, которые нам нужны в проекте.
struct CurrentWeatherData: Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main: Codable {
    let temp : Double
    let feelsLike : Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id : Int
}


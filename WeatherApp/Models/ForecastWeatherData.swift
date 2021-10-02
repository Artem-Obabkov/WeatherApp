//
//  ForecastWeatherData.swift
//  WeatherApp
//
//  Created by pro2017 on 01/10/2021.
//

import Foundation

struct ForecastWeatherData: Codable {
    let forecast : Forecast
}

struct Forecast: Codable {
    let forecastday : [Forecastday]
}

struct Forecastday: Codable {
    let date : String
    let day : Day
}

struct Day: Codable {
    let maxtempC : Double
    let mintempC : Double
    let condition : Condition
    
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
    }
}

struct Condition: Codable {
    let icon : String
}

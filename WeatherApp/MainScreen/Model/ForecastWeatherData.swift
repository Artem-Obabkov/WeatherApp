//
//  ForecastWeatherData.swift
//  WeatherApp
//
//  Created by pro2017 on 01/10/2021.
//

import Foundation

struct ForecastWeatherData: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Current
struct Current: Codable {
    let tempC: Int
    let condition: Condition
    let feelslikeC: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case feelslikeC = "feelslike_c"
    }
}

// MARK: - Location
struct Location: Codable {
    let name: String
}

// MARK: - Condition
struct Condition: Codable {
    let icon: String
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String
    let day: Day
}

// MARK: - Day
struct Day: Codable {
    let maxtempC, mintempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
    }
}




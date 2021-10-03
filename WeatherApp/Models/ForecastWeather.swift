//
//  ForecastWeather.swift
//  WeatherApp
//
//  Created by pro2017 on 02/10/2021.
//

import Foundation

struct ForecastWeather {
    
    let forecastDayArray: [Forecastday]
    
    func getForecastArray() -> [ForecastCellModel] {
        var forecastWeather = [ForecastCellModel]()
        
        for day in forecastDayArray {
            let imageString = getImageString(imageLink: day.day.condition.icon)
            let dateString = getDateString(fromDate: day.date)
            let maxTempString = "\(String(day.day.maxtempC))°C"
            let minTempString = "\(String(day.day.mintempC))°C"
            let avrTempString = "\(getAverageTemp(minTemp: day.day.mintempC, maxTemp: day.day.maxtempC))°C"
            let dayOfWeek = getDayOfTheWeek(fromDate: day.date)
            
            let forecastWeatherItem = ForecastCellModel(weatherImage: imageString, date: dateString, day: dayOfWeek, maxTemp: maxTempString, minTemp: minTempString, avrTemp: avrTempString)
            
            forecastWeather.append(forecastWeatherItem)
        }
        
        return forecastWeather
    }
    
    // Получаем systName для дальнейшего присвоения его в weatherImage в ячейке TableView
    fileprivate func getImageString(imageLink link: String) -> String {
        var result = ""
        
        let suffix = link.suffix(7)
        guard let preffix = Int(suffix.prefix(3)) else { return ""}
        
        switch preffix {
        case 113: result = "sun.max"
        case 116, 323, 329, 335, 368...377: result = "cloud.sun"
        case 119...122: result = "cloud"
        case 143, 248, 260: result = "cloud.fog"
        case 176, 179, 182, 293, 299, 305, 353...365: result = "cloud.sun.rain"
        case 185, 281, 284, 311, 314: result = "cloud.drizzle"
        case 200, 386, 392: result = "cloud.sun.bolt"
        case 227, 230, 326, 332, 338, 350: result = "cloud.snow"
        case 263, 266, 296, 302, 308, 317, 320: result = "cloud.rain"
        case 389, 395: result = "cloud.bolt"
        default:
            result = "nosign"
        }
        
        return result
    }
    
    // Преобразовываем дату из формата 2021-10-03 в 03.10.2021
    fileprivate func getDateString(fromDate currentDate: String) -> String {
        var resultDate = ""
        
        let dateArray = currentDate.components(separatedBy: "-")
        resultDate = "\(dateArray[2]).\(dateArray[1])"
        
        return resultDate
    }
    
    // Получаем среднюю температуру и обрезаем ее до десятичных долей
    fileprivate func getAverageTemp(minTemp: Double, maxTemp: Double) -> String {
        var tempResult = ""
        
        let avrTemp = (maxTemp + minTemp) / 2
        switch avrTemp {
        case -99.9 ... -9.9 : tempResult = String(String(avrTemp).prefix(5))
        case ...0 : tempResult = String(String(avrTemp).prefix(4))
        case 0...9.9 : tempResult = String(String(avrTemp).prefix(3))
        case 9.9... : tempResult = String(String(avrTemp).prefix(4))
        default :
            tempResult = String(String(avrTemp).prefix(5))
        }
        
        return tempResult
    }
    
    // Получаем день недели с помощью даты и календаря
    fileprivate func getDayOfTheWeek(fromDate currentDate: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = dateFormatter.date(from: currentDate) else { return ""}
        let calendar = Calendar(identifier: .gregorian)
        let weekday = calendar.component(.weekday, from: todayDate)
        
        switch weekday {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default :
            return ""
        }
    }

    init?(forecastWeatherData: ForecastWeatherData) {
        forecastDayArray = forecastWeatherData.forecast.forecastday
    }
}

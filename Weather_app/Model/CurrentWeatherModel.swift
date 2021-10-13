//
//  WeatherModel.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 09.10.21.
//

import UIKit


struct CurrentWeatherModel {
    var weatherIcon: Int
    var weatherIconCode: String
    var cityName: String
    var countryCode: String
    var temperature: String
    var weatherCondition: String
    var chanceOfRain: Double
    var humidity: String
    var pressure: String
    var windSpeed: Double
    var windDirection: Int
    var weekDays: Int
    
    //MARK: - Computed Properties
    
    //chance of rain
    var formattedChanceOfRain: String {
        return "\(Int(chanceOfRain * 100))%"
    }
    
    //wind speed
    var formattedWindSpeed: String {
        return "\(String(format: "%.1f", windSpeed)) km/h"
    }
    
    //wind direction
    var windDirections: String {
        switch windDirection {
        case 0...11:
            return "N"
        case 11...33:
            return "NNE"
        case 33...56:
            return "NE"
        case 56...78:
            return "ENE"
        case 78...101:
            return "E"
        case 101...123:
            return "ESE"
        case 123...146:
            return "SE"
        case 146...168:
            return "SSE"
        case 168...191:
            return "S"
        case 191...213:
            return "SSW"
        case 213...236:
            return "SW"
        case 236...258:
            return "WSW"
        case 258...281:
            return "W"
        case 281...303:
            return "WNW"
        case 303...326:
            return "NW"
        case 326...348:
            return "NNW"
        case 348...360:
            return "N"
        default:
            return "_"
        }
    }
    
    init(model: AllWeather) {
        let current = model.list[0]
        self.weatherIcon = current.weather[0].weatherIcon
        self.weatherIconCode = current.weather[0].weatherIconCode
        self.countryCode = model.city.country
        self.cityName = "\(model.city.name), \(self.countryCode)"
        self.weatherCondition = current.weather[0].condition
        self.temperature = "\(String(format: "%.0f", current.mainDetails.temp))° | \(self.weatherCondition)"
        self.chanceOfRain = current.chanceOfRain
        self.humidity = "\(current.mainDetails.humidity)%"
        self.pressure = "\(current.mainDetails.pressure) hPa"
        self.windSpeed = current.wind.windSpeed
        self.windDirection = current.wind.windDirection
        self.weekDays = current.weekDay
    }
}

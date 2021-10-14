//
//  WeatherModel.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 09.10.21.
//


import UIKit

struct AllWeather: Decodable {
    let list: [WeatherData]
    let city: City
}

// Data
struct WeatherData: Decodable {
    let mainDetails: Main
    let weather: [WeatherCondition]
    let wind: Wind
    let chanceOfRain: Double
    let currentTime: String
    
    private enum CodingKeys: String, CodingKey {
        case mainDetails = "main"
        case weather
        case wind
        case chanceOfRain = "pop"
        case currentTime = "dt_txt"
    }
}

//Main
struct Main: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

// Condition
struct WeatherCondition: Decodable  {
    let weatherIcon: Int
    let condition: String
    let weatherIconCode: String
    
    private enum CodingKeys: String, CodingKey {
        case weatherIcon = "id"
        case condition = "description"
        case weatherIconCode = "icon"
    }
}

// Wind
struct Wind: Decodable {
    let windSpeed: Double
    let windDirection: Int
    
    private enum CodingKeys: String, CodingKey {
        case windSpeed = "speed"
        case windDirection = "deg"
    }
}

// City
struct City: Decodable {
    var name: String
    let country: String
}

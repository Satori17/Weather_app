//
//  Icons.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 11.10.21.
//


import UIKit

 func WeatherIcons(iconCode:String, iconId: Int) -> UIImage {
    if iconCode.contains("d") {
        switch iconId {
        case 200...232:
            return #imageLiteral(resourceName: "ThunderStorm")
        case 300...321:
            return #imageLiteral(resourceName: "Drizzle")
        case 500...531:
            return #imageLiteral(resourceName: "Rain_day")
        case 600...622:
            return #imageLiteral(resourceName: "Snow_day")
        case 701...781:
            return #imageLiteral(resourceName: "Wind_day")
        case 800:
            return #imageLiteral(resourceName: "ClearSky_day")
        case 801...804:
            return #imageLiteral(resourceName: "Clouds_day")
        default:
            return #imageLiteral(resourceName: "ScatteredClouds")
        }
    } else {
        switch iconId {
        case 200...232:
            return #imageLiteral(resourceName: "ThunderStorm")
        case 300...321:
            return #imageLiteral(resourceName: "Drizzle")
        case 500...531:
            return #imageLiteral(resourceName: "Rain_night")
        case 600...622:
            return #imageLiteral(resourceName: "Snow_night")
        case 701...781:
            return #imageLiteral(resourceName: "Wind_night")
        case 800:
            return #imageLiteral(resourceName: "ClearSky_night")
        case 801...804:
            return #imageLiteral(resourceName: "Clouds_night")
        default:
            return #imageLiteral(resourceName: "ScatteredClouds")
        }
    }
}

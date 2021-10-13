//
//  APINetworking.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 09.10.21.
//

import Foundation

struct Keys {
    
    private static let apiKey = "5730e0ce7556759fedf4539f6ea80c40"
    let url =  "https://api.openweathermap.org/data/2.5/forecast?"
    let configured = apiKey + "&units=metric"
}

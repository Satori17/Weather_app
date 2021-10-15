//
//  ForecastVC.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 08.10.21.
//

import UIKit
import CoreLocation
import Alamofire


class ForecastVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var forecastTableview: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let keys = Keys()
    var loadingView = LoadingView()
    var allForecast = [WeatherData]()
    //creating view for internet connection
    var connectionBackground = UIView()
    //for formatting fetched current dates
    var formattedDate = [Date]()
    var transformedDate = [String]()
    var weekDaysArray = [String]()
    var dateArray = [String]()
    var filteredWeekDays: [String]?
    //fetched weather arrays
    var today: [WeatherData] = []
    var day2: [WeatherData] = []
    var day3: [WeatherData] = []
    var day4: [WeatherData] = []
    var day5: [WeatherData] = []
    var day6: [WeatherData] = []
    //data array for fetched weather arrays
    var allWeatherData = [[WeatherData]]()
    //counter of fetching. controls populating tableview on the first fetch
    var guardCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNetwork()
        loadingView.loading(vc: self)
    }
}

//MARK: - Extension

extension ForecastVC: CLLocationManagerDelegate {
    
    //updating location
    func setLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    //getting current longitude&latitude
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    // Fetching Weather location
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(keys.url)lat=\(latitude)&lon=\(longitude)&appid=\(keys.key)\(keys.unit)"
        fetchData(with: urlString)
    }
    
    // Fetching Weather Data
    func fetchData(with url: String) {
        let request = AF.request(url)
            .validate()
        request.responseDecodable(of: AllWeather.self) { (response) in
            if response.error != nil {
                print(String(describing: response.error?.localizedDescription))
            } else {
                self.guardCounter += 1
                if self.guardCounter == 1 {
                    guard let forecast = response.value else { return }
                    self.allForecast = forecast.list
                    //formatting week days data
                    for i in forecast.list {
                        self.weekDaysArray.append(self.DaysOfWeek(day: i.currentTime))
                    }
                    //Main function which fully loads all weather data
                    self.makeTableViewViewable()
                }
                DispatchQueue.main.async {
                    self.forecastTableview.reloadData()
                }
            }
        }
    }
    
    //MARK: - Functions
    
    //get week day
    func DaysOfWeek(day: String) -> String {
        let currentDate = day.dropLast(9)
        return String(currentDate)
    }
    
    // transform string week day as Date
    func transformDate(currentDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:currentDate)!
        
        return date
    }
    
    func getWeekDay(currentDate: Date) -> String {
        let dateFormatter = DateFormatter()
        let rightWeek = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: currentDate)-1]
        return String(rightWeek)
    }
    
    func makeTableViewViewable() {
        //transforming string dates as Date
        for i in self.weekDaysArray {
            self.formattedDate.append(self.transformDate(currentDate: i))
        }
        //Date as week day strings
        for i in self.formattedDate {
            self.transformedDate.append(self.getWeekDay(currentDate: i))
        }
        //filtering week days
        self.dateArray = self.weekDaysArray.removingDuplicates()
        //for getting current sections
        self.getcurrentSections()
        //appending fetched weather arrays to all weather data
        self.allWeatherData.append(self.today)
        self.allWeatherData.append(self.day2)
        self.allWeatherData.append(self.day3)
        self.allWeatherData.append(self.day4)
        self.allWeatherData.append(self.day5)
        if self.today.count < 8 {
            self.allWeatherData.append(self.day6)
        }
        //removing duplicate elements from array
        self.filteredWeekDays = self.transformedDate.removingDuplicates()
        //remove first element to implement "today" as name of first day
        self.filteredWeekDays?.insert("Today", at: 1)
        self.filteredWeekDays?.removeFirst()
        //loadingView
        self.loadingView.loadingIndicator.stopAnimating()
        self.loadingView.loadingBackground.isHidden = true
    }
}

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
    var weekDay = String()
    var weekDaysArray = [String]()
    var filteredWeekDays = [String]()
    //counters for assigning right weathers to right sections
    var counter = 0
    var counter1 = 0
    var counter2 = 0
    var counter3 = 0
    var counter4 = 0
    //fetched weather arrays
    var today: [WeatherData] = []
    var day2: [WeatherData] = []
    var day3: [WeatherData] = []
    var day4: [WeatherData] = []
    var day5: [WeatherData] = []
    var day6: [WeatherData] = []
    //data array for fetched weather array
    var allWeatherData = [[WeatherData]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        loadingView.loading(vc: self)
        navigationItem.title = currentWeatherModel.cityName
    }
    
    //get week day
    func DaysOfWeek(fromDate: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(fromDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.string(from: date)
        return dayOfWeekString
    }
}

//MARK: - Extension

extension ForecastVC: CLLocationManagerDelegate {
    
    //updating location
    private func setLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
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
        let urlString = "\(keys.url)lat=\(latitude)&lon=\(longitude)&appid=\(keys.configured)"
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
                guard let forecast = response.value else { return }
                self.allForecast = forecast.list
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
                //formatting week days data
                for i in forecast.list {
                    self.weekDaysArray.append(self.DaysOfWeek(fromDate: i.weekDay))
                }
                //filtering week days
                self.filteredWeekDays = self.weekDaysArray.removingDuplicates()
                //loadingView
                self.loadingView.loadingIndicator.stopAnimating()
                self.loadingView.loadingBackground.isHidden = true
            }
            DispatchQueue.main.async {
                self.forecastTableview.reloadData()
            }
        }
    }
}

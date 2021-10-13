//
//  ViewController.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 08.10.21.
//


import UIKit
import CoreLocation
import Alamofire

var currentWeatherModel: CurrentWeatherModel!


class MainVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var possibleRainLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    //detail UIViews
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var rainView: UIView!
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var directionView: UIView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let keys = Keys()
    var loadingView = LoadingView()
    //for presenting permission view
    let permissionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PermissionVC") as! PermissionVC
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIChanges()
        setLocation()
        loadingView.loading(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCurrentPermission()
    }
    
    //MARK: - IBAction
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let text = "\(currentWeatherModel.temperature), \(currentWeatherModel.cityName) by Weather_app"
        let activityController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    //MARK: - Extra Functions
    
    //requesting location
    private func setLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //checking current location permissions
    func checkCurrentPermission() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            permissionVC.dismiss(animated: true, completion: nil)
        case .notDetermined:
            break
        case .denied, .restricted:
            self.present(permissionVC, animated: true, completion: nil)
        @unknown default:
            print("Location services are unavailable")
        }
    }
    
    //checking global location permissions
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            self.present(permissionVC, animated: true, completion: nil)
        case .authorizedWhenInUse, .authorizedAlways:
            dismiss(animated: true, completion: nil)
        case .notDetermined:
            break
        @unknown default:
            print("other")
        }
    }
    
    //for showing current weather details
    func showWeather(with Model: CurrentWeatherModel) {
        self.weatherImageView.image = WeatherIcons(iconCode: Model.weatherIconCode, iconId: Model.weatherIcon)
        self.humidityLabel.text = Model.humidity
        self.locationLabel.text = Model.cityName
        self.possibleRainLabel.text = Model.formattedChanceOfRain
        self.pressureLabel.text = Model.pressure
        self.temperatureLabel.text = Model.temperature
        self.windDirectionLabel.text = Model.windDirections
        self.windSpeedLabel.text = Model.formattedWindSpeed
    }
}

//MARK: - Extension

extension MainVC : CLLocationManagerDelegate {
    
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
                self.loadingView.loadingIndicator.stopAnimating()
                self.loadingView.loadingBackground.isHidden = true
                
                currentWeatherModel = CurrentWeatherModel(model: forecast)
                self.showWeather(with: currentWeatherModel)
            }
        }
    }
}

extension MainVC {
    private func UIChanges() {
        //humidity
        humidityView.layer.cornerRadius = 25
        humidityView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        humidityView.layer.shadowRadius = 10
        humidityView.layer.shadowOpacity = 1
        humidityView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.5).cgColor
        //rain
        rainView.layer.cornerRadius = 25
        rainView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        rainView.layer.shadowRadius = 10
        rainView.layer.shadowOpacity = 1
        rainView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.5).cgColor
        //pressure
        pressureView.layer.cornerRadius = 25
        pressureView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        pressureView.layer.shadowRadius = 10
        pressureView.layer.shadowOpacity = 1
        pressureView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.5).cgColor
        //wind speed
        windView.layer.cornerRadius = 25
        windView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        windView.layer.shadowRadius = 10
        windView.layer.shadowOpacity = 1
        windView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.5).cgColor
        //wind direction
        directionView.layer.cornerRadius = 25
        directionView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        directionView.layer.shadowRadius = 10
        directionView.layer.shadowOpacity = 1
        directionView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.5).cgColor
        //icon
        weatherImageView.layer.shadowOffset = CGSize(width: 5.0, height: 0.0)
        weatherImageView.layer.shadowRadius = 10
        weatherImageView.layer.shadowOpacity = 1
        weatherImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0.0, alpha: 0.8).cgColor
    }
}
//
//  ViewController.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 08.10.21.
//

import UIKit
import Alamofire
import CoreLocation


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
    var loadingView = LoadingView()
    //creating view for internet connection
    var connectionBackground = UIView()
    //for presenting permission view
    let permissionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PermissionVC") as! PermissionVC
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNetwork()
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
    func setLocation() {
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
            print("Location services are unavailable")
        }
    }
    
    //for showing current weather details
    private func showWeather(with Model: CurrentWeatherModel) {
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
        let urlString = "\(Keys.url)lat=\(latitude)&lon=\(longitude)&appid=\(Keys.key)\(Keys.unit)"
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
                self.shareButton.isEnabled = true
                currentWeatherModel = CurrentWeatherModel(model: forecast)
                self.showWeather(with: currentWeatherModel)
            }
        }
    }
}


//Design changes
extension MainVC {
    private func UIChanges(for view: UIView) {
        view.layer.cornerRadius = 25
        view.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.5).cgColor
    }
    
    private func imageViewUIChanges(for image: UIImageView) {
        image.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        image.layer.shadowRadius = 5
        image.layer.shadowOpacity = 1
        image.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0.0, alpha: 0.7).cgColor
    }
    
    func getAllUIViewChanges() {
        let allUIView = [humidityView, rainView, pressureView, windView, directionView, weatherImageView]
        
        for view in allUIView {
            if view == weatherImageView {
                if let imageView = view as? UIImageView {
                    imageViewUIChanges(for: imageView)
                }
            } else {
                if let uiView = view {
                    UIChanges(for: uiView)
                }
            }
        }
    }
}

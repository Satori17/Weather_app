//
//  InternetConnection.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 14.10.21.
//

import Foundation
import Network
import UIKit


private func noConnectionView(vc: UIViewController, view: UIView) {
    view.frame = vc.view.bounds
    view.backgroundColor = .gray
    view.alpha = 1
    vc.view.addSubview(view)
}

//MARK: - Detect internet connection availability
extension MainVC {
    
    func checkNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.setLocation()
                    //self.UIChanges()
                    self.getAllUIViewChanges()
                    self.navigationItem.title = "Today"
                    self.shareButton.isEnabled = true
                    self.connectionBackground.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.locationManager.stopUpdatingLocation()
                    self.navigationItem.title = "No Internet Connection"
                    self.shareButton.isEnabled = false
                    self.connectionBackground.isHidden = false
                    noConnectionView(vc: self, view: self.connectionBackground)
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
}

extension ForecastVC {
    
    func checkNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.setLocation()
                    self.navigationItem.title = currentWeatherModel.cityName
                    self.connectionBackground.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.locationManager.stopUpdatingLocation()
                    self.navigationItem.title = "No Internet Connection"
                    self.connectionBackground.isHidden = false
                    noConnectionView(vc: self, view: self.connectionBackground)
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
}

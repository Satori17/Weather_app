//
//  InternetConnection.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 14.10.21.
//

import Foundation
import Network

//MARK: - Detect internet connection availability
extension MainVC {
    
    func checkNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.setLocation()
                    self.loadingView.loading(vc: self)
                    self.UIChanges()
                    self.navigationItem.title = "Today"
                    let tabBarItem = self.tabBarController!.tabBar.items![1]
                    tabBarItem.isEnabled = true
                    self.shareButton.isEnabled = true
                    self.connectionBackground.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.locationManager.stopUpdatingLocation()
                    self.navigationItem.title = "No Internet Connection"
                    let tabBarItem = self.tabBarController!.tabBar.items![1]
                    tabBarItem.isEnabled = false
                    self.shareButton.isEnabled = false
                    self.connectionBackground.isHidden = false
                    self.noConnectionView()
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
    func noConnectionView() {
        connectionBackground.frame = self.view.bounds
        connectionBackground.backgroundColor = .gray
        connectionBackground.alpha = 1
        self.view.addSubview(connectionBackground)
    }
}

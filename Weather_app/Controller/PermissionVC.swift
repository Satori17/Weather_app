//
//  PermissionVC.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 11.10.21.
//

import UIKit
import CoreLocation

class PermissionVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gpsButton: UIButton!
    
    let locationManager = CLLocationManager()
    var infoText = "Location Services are disabled"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = infoText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        infoLabel.text = infoText
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gpsButton.isHidden = false
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - IBAction
    @IBAction func accessButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Location Services are disabled", message: "Please, enable GPS in the Settigs app under Privacy, Location Services", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { action in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.infoLabel.text = "Dismiss View to get access"
                    self.gpsButton.isHidden = true
                    if #available(iOS 13.0, *) {
                        self.isModalInPresentation = false
                    } else {
                        return
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

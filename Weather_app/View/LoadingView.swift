//
//  LoadingView.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 11.10.21.
//

import Foundation
import UIKit

struct LoadingView {
    
    var loadingBackground = UIView()
    var loadingIndicator = UIActivityIndicatorView()
    
    func loading(vc: UIViewController) {
            //adding background subview
            loadingBackground.frame = vc.view.bounds
            loadingBackground.backgroundColor = .gray
        loadingBackground.alpha = 0.5
            loadingBackground.translatesAutoresizingMaskIntoConstraints = false
            //adding loading indicator
            if #available(iOS 13.0, *) {
                loadingIndicator.style = .large
            } else {
                loadingIndicator.style = .gray
            }
            loadingIndicator.startAnimating()
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.center = vc.view.center
            vc.view.addSubview(loadingIndicator)
            vc.view.addSubview(loadingBackground)
    }
}

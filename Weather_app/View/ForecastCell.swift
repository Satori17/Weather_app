//
//  ForecastCell.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 09.10.21.
//

import UIKit

class ForecastCell: UITableViewCell {

  //MARK: - IBOutlets
    @IBOutlet weak var forecastImageView: UIImageView!
    @IBOutlet weak var forecastTimeLabel: UILabel!
    @IBOutlet weak var forecastconditionLabel: UILabel!
    @IBOutlet weak var forecastTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

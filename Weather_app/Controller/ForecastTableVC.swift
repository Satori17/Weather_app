//
//  ForecastTableVC.swift
//  Weather_app
//
//  Created by Saba Khitaridze on 12.10.21.
//


import UIKit


extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if day6.count != 0 {
            return 6
        } else {
            return allWeatherData.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UINib(nibName: "Header", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HeaderView
          
            if let weekDays = filteredWeekDays?[section] {
                view.weekDaysLabel.text = weekDays
            }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allWeatherData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell") as! ForecastCell
        let currentWeather = allWeatherData[indexPath.section][indexPath.row]
        let currentIcon = currentWeather.weather[0]
        let time = currentWeather.currentTime.dropFirst(11).dropLast(3)
        
        cell.forecastImageView.image = WeatherIcons(iconCode: currentIcon.weatherIconCode, iconId: currentIcon.weatherIcon)
        cell.forecastTimeLabel.text = "\(time)"
        cell.forecastTemperatureLabel.text = "\(String(format: "%.0f", currentWeather.mainDetails.temp))°"
        cell.forecastconditionLabel.text = currentIcon.condition
        //UI
        if #available(iOS 13.0, *) {
            cell.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        } else {
            cell.layer.borderColor = UIColor.white.cgColor
        }
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 20
        cell.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 1
        cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.5).cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    //MARK: - Extra Functions
    
    //right weathers for right sections
    func getcurrentSections() {
        for element in allForecast {
            let formattedTime = element.currentTime.dropLast(9)
            if formattedTime == dateArray[0] {
                today.append(element)
            } else if formattedTime == dateArray[1] {
                day2.append(element)
            } else if formattedTime == dateArray[2] {
                day3.append(element)
            } else if formattedTime == dateArray[3] {
                day4.append(element)
            } else if formattedTime == dateArray[4] {
                day5.append(element)
            } else {
                if today.count < 8 {
                day6.append(element)
                }
            }
        }
    }
}

// for filtering fetched week days
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

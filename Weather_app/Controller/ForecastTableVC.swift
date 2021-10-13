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
        if section == 0 {
            view.weekDaysLabel.text = "Today"
        } else {
            view.weekDaysLabel.text =  filteredWeekDays[section]
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
    
    //getting current date info
    func currentDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let date = dateFormater.string(from: NSDate() as Date)
        return date
    }
    
    //right sections for right days
    func getcurrentSections() {
        //today
        for i in allForecast {
            if i.currentTime.dropLast(9) == currentDate() {
                today.append(i)
            }
        }
        if allForecast.count > today.count {
            allForecast.removeFirst(today.count)
        }
        //day 2
        for i in allForecast {
            if counter != 8 {
                day2.append(i)
                counter += 1
            }
        }
        if allForecast.count > day2.count {
            allForecast.removeFirst(day2.count)
        }
        //day 3
        for i in allForecast {
            if counter1 != 8 {
                day3.append(i)
                counter1 += 1
            }
        }
        if allForecast.count > day3.count {
            allForecast.removeFirst(day3.count)
        }
        //day 4
        for i in allForecast {
            if counter2 != 8 {
                day4.append(i)
                counter2 += 1
            }
        }
        if allForecast.count > day4.count {
            allForecast.removeFirst(day4.count)
        }
        //day 5
        for i in allForecast {
            if counter3 != 8 {
                day5.append(i)
                counter3 += 1
            }
        }
        if allForecast.count > day5.count {
            allForecast.removeFirst(day5.count)
        }
        //day 6
        for i in allForecast {
            if counter4 != (8 - today.count) {
                day6.append(i)
                counter4 += 1
            }
        }
        if allForecast.count > day6.count {
            allForecast.removeFirst(day6.count)
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

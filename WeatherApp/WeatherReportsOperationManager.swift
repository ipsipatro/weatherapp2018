//
//  WeatherReportsOperationManager.swift
//  WeatherApp
//
//  Created by Ipsi Patro on 11/03/2018.
//  Copyright © 2018 Ipsi Patro. All rights reserved.
//

import UIKit

class WeatherReportsOperationManager: NSObject {
    
    var weather: Weather?
    var weatherReportFetchedSuccessfully = true
    var weathers = [Weather]()

    static let sharedInstance = WeatherReportsOperationManager()
    fileprivate override init() {}
    
    // MARK: - Public
    
    func getWeatherReportForCity(city:String, completion: @escaping () -> () = {}) {
        weather = nil
        if !city.isEmpty {
            let urlString = "http://api.apixu.com/v1/current.json?key=9de9e1b2c05f484c878154957181003&q=\(city))"
            guard let url = URL(string: urlString) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    guard let data = data else{return}
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            let weatherJson = self.parseJsonToGetWeatherJson(data: json)
                            self.populateWeatherWith(json: weatherJson)
                        }
                    }catch let errorCondition {
                        print("error is \(errorCondition)")
                    }

                }
                completion()
            }.resume()
        }
        
    }
    func loadSerchedWeathers() {
        if let serchedWeathers = loadWeathers() {
            self.weathers = serchedWeathers
        }
    }
    
    func getCurrentWeather() -> Weather? {
        return weather
    }
    
    func loadWeathers() -> [Weather]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Weather.ArchiveURL.path) as? [Weather]
    }
    
    // MARK: - Private
    private func parseJsonToGetWeatherJson(data: [String: Any]) -> [String: Any] {
        var json = [String: Any]()
        
        if let location =  data["location"] as? [String: Any] {
            if let cityName = location["name"] as? String {
                json["cityName"] = cityName
            }
        }
        if let current = data["current"] as? [String: Any] {
            if let temp = current["temp_c"] as? Int {
                json["temperature"] = temp
            }
            if let condition = current["condition"] as? [String: Any] {
                if let weatherCondition = condition["text"] as? String  {
                     json["weatherCondition"] = weatherCondition
                }
                if let iconImageURLString = condition["icon"] as? String  {
                    let imageurl = "http:\(iconImageURLString)"
                    json["iconImageURLString"] = imageurl
                }
            }
            var windSpeedAndDirection = ""
            
            if let direction = current["wind_dir"] as? String {
                windSpeedAndDirection += direction
            }
            if let windSpeed = current["wind_mph"] as? Double {
                windSpeedAndDirection += " "+windSpeed.description+"mph"
            }
            if !windSpeedAndDirection.isEmpty {
                json["windSpeedAndDirection"] = windSpeedAndDirection
            }
        }
        return json
    }
    
    private func populateWeatherWith(json: [String: Any]) {
        if let cityName = json["cityName"] as? String {
            weather = Weather.init(cityName: cityName, iconURL: json["iconImageURLString"] as? String, temperature: json["temperature"] as? Int, weatherCondition: json["weatherCondition"] as? String,windSpeedAndDirection: json["windSpeedAndDirection"]  as? String)
            weatherReportFetchedSuccessfully = true
            addCityToSave()
            saveCities()
        }
        
    }
    private func saveCities() {
        NSKeyedArchiver.archiveRootObject(weathers, toFile: Weather.ArchiveURL.path)
    }
    
    private func addCityToSave() {
        var cityFound = false
        if let currentWeather = weather {
            for weather in weathers {
                if currentWeather.cityName == weather.cityName {
                    cityFound = true
                }
            }
            if !cityFound {
                weathers.append(currentWeather)
            }
        }
    }

}

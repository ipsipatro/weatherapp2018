//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Ipsi Patro on 10/03/2018.
//  Copyright © 2018 Ipsi Patro. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UISearchBarDelegate {

@IBOutlet weak var searchBar: UISearchBar!

@IBOutlet weak var cityNameLabel: UILabel!

@IBOutlet weak var weatherConditionLabel: UILabel!

@IBOutlet weak var temperatureLabel: UILabel!

@IBOutlet weak var iconImageView: UIImageView!
    
@IBOutlet weak var windSpeedAndDirectionLabel: UILabel!
    
@IBOutlet weak var windLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
    super.viewDidLoad()
        searchBar.delegate = self
        WeatherReportsOperationManager.sharedInstance.loadSerchedWeathers()
    }
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            WeatherReportsOperationManager.sharedInstance.getWeatherReportForCity(city:"\(text.replacingOccurrences(of: " ", with: "%20"))", completion: {self.updateView()})
        }
    }
    
    // MARK: - private methods
    
    private func updateView() {
        DispatchQueue.main.async {
            self.setHiddenPropertiesForViews()
            if let weather = WeatherReportsOperationManager.sharedInstance.weather {
                self.cityNameLabel.text = weather.cityName
                self.temperatureLabel.text = weather.temperature?.description
                self.weatherConditionLabel.text = weather.weatherCondition
                let url = URL(string: (weather.iconImageURL)!)
                let data = try? Data(contentsOf: url!)
                if let data = data {
                    self.iconImageView.image = UIImage(data: data)
                }
                self.windSpeedAndDirectionLabel.text = weather.windSpeedAndDirection
            }else {
                self.cityNameLabel.text = "City not found"
            }
        }
    }
    
    private func setHiddenPropertiesForViews() {
         var noResultsFound = true
        if let _ = WeatherReportsOperationManager.sharedInstance.weather {
            noResultsFound = false
        }
        self.temperatureLabel.isHidden = noResultsFound
        self.weatherConditionLabel.isHidden = noResultsFound
        self.iconImageView.isHidden = noResultsFound
        self.windSpeedAndDirectionLabel.isHidden = noResultsFound
        self.windLabel.isHidden = noResultsFound
        
    }
    
    // MARK: - Navigation
    @IBAction func unwindSegueFromCityListController(_ sender: UIStoryboardSegue) {
        if sender.source is FavouriteCitiesViewController {
            if let senderVC = sender.source as? FavouriteCitiesViewController, let cityName = senderVC.selectedCityName{
                WeatherReportsOperationManager.sharedInstance.getWeatherReportForCity(city: cityName, completion: {self.updateView()})
            }
        }
    }
}

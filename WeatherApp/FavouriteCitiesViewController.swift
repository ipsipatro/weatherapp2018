//
//  FavouriteCitiesViewController.swift
//  WeatherApp
//
//  Created by Ipsi Patro on 11/03/2018.
//  Copyright © 2018 Ipsi Patro. All rights reserved.
//

import UIKit

class FavouriteCitiesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var weatherList = [Weather]()
    var selectedCityName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let weatherList = WeatherDataManager.getSavedWeatherList() {
            self.weatherList = weatherList
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityTableViewCell", for: indexPath) as! FavouriteCitiesTableViewCell
        let weather = weatherList[indexPath.row]
        cell.weather = weather
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWeather = weatherList[indexPath.row]
        self.selectedCityName = selectedWeather.cityName
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndex = tableview.indexPathForSelectedRow?.row {
            let selectedWeather = weatherList[selectedIndex]
            self.selectedCityName = selectedWeather.cityName

        }
        
    }
   
}

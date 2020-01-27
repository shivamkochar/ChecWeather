//
//  DailyWeatherReportViewController.swift
//  Assignment2
//
//  Created by Ankit Shah on 2019-12-07.
//  Copyright © 2019 Ankit Shah. All rights reserved.
//

import UIKit
import CoreLocation
class DailyWeatherReportViewController: UITableViewController, UISearchBarDelegate {
  
  @IBOutlet weak var cityNameNavlbl: UINavigationItem!
  
  var weather = Weather()
  
  var wData: WeatherData?
  
  var info = LocationInformation()
  
  @IBOutlet var dailyWeatherTable: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    
    LocationManagerUtility.shared.start { (info) in
      let city = info.city
      self.updateWeatherForLocation(location: city!)
    }
    
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let locationString = searchBar.text, !locationString.isEmpty {
      updateWeatherForLocation(location: locationString)
    }
    
  }
  
  // updating table cells based on city
  func updateWeatherForLocation (location:String) {
    CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
      if error == nil {
        if let loc = placemarks?.first?.location {
          self.info.latitude = loc.coordinate.latitude
          self.info.longitude = loc.coordinate.longitude
          self.info.city = location
          self.cityNameNavlbl.title = self.info.city?.uppercased()
          self.weather.decodingWeatherApi(location: self.info, urlString: self.weather.fetchApiDetails(location: self.info), completion: { (results: WeatherData?) in
            
            if let weatherData = results {
              self.wData = weatherData
              
              DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
              }
              
            }
            
          })
        }
      }
    }
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Table view data source
  
  // returns number of sections
  override func numberOfSections(in tableView: UITableView) -> Int {
    guard let wData = self.wData else{
      
      return 0
    }
    return wData.daily.data.count
  }
  
  // returns number of rows
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  // inserting date and time for header of each cell in the form of Friday, December 13, 2019
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
    
    return dateFormatter.string(from: date!)
  }
  
  // populating cell data from WeatherData struct
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    guard let wData = self.wData else{
      print("No data exists!!!")
      return cell
    }
    let weatherObject = wData.daily.data[indexPath.section]
    
    cell.textLabel?.text = weatherObject.summary
    cell.detailTextLabel?.text = "Min: \(Int(weatherObject.temperatureMin))   Max: \(Int(weatherObject.temperatureMax)) °C"
    cell.imageView?.image = UIImage(named: weatherObject.icon)
    
    return cell
  }
}

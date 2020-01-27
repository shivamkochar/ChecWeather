//
//  ViewController.swift
//  Assignment2
//
//  Created by Ankit Shah on 2019-12-04.
//  Copyright © 2019 Ankit Shah. All rights reserved.
//

import UIKit
import CoreLocation

// Populates weather data with the use of API data from https://darksky.net
// We have took some of the icons from https://www.flaticon.com/

class ViewController: UIViewController{
  
  var weather = Weather()
  
  var urlString: String?
  
  let info = LocationInformation()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    LocationManagerUtility.shared.start { (info) in
      
      self.info.city = info.city
      self.info.latitude = info.latitude
      self.info.longitude = info.longitude
      
      self.urlString = self.weather.fetchApiDetails(location: self.info)
      print(self.urlString!)
      self.getData(location: self.info, urlString: self.urlString!)
    }
  }
  
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var weatherLabel: UILabel!
  @IBOutlet weak var weatherImage: UIImageView!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var feelsLikeLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var windSpeedLabel: UILabel!
  @IBOutlet weak var windDirectionLabel: UILabel!
  @IBOutlet weak var sunRiseLabel: UILabel!
  @IBOutlet weak var sunsetLabel: UILabel!
  
  
  // setting landing page informtion based on the user's current location
  func setLandingPageInfo(location: LocationInformation, wData: WeatherData) {
    DispatchQueue.main.async{
      self.temperatureLabel.text = String(Int(wData.currently.temperature)) + " °C"
      self.humidityLabel.text = String(Int(Float(wData.currently.humidity) * 100)) + "%"
      self.feelsLikeLabel.text = String(Int(wData.currently.apparentTemperature)) + " °C"
      self.windSpeedLabel.text = (String(Int(wData.currently.windSpeed * 3.6)) ) + " km/hr"
      self.windDirectionLabel.text = self.weather.windDirectionFromDegrees(degrees: wData.currently.windBearing)
      self.summaryLabel.text = wData.currently.summary
      self.sunRiseLabel.text = self.weather.convertUnixTimeToLocalTime(unixTime: wData.daily.data[0].sunriseTime)
      self.sunsetLabel.text = self.weather.convertUnixTimeToLocalTime(unixTime: wData.daily.data[0].sunsetTime)
      self.weatherLabel.text = wData.currently.icon
      self.weatherImage.image = UIImage(named: wData.currently.icon)
        self.cityLabel.text = location.city?.uppercased()
    }
  }
  
  // getting API data to set in landing page components
  func getData(location: LocationInformation, urlString: String) {
    weather.decodingWeatherApi(location: location, urlString: urlString, completion: { (results: WeatherData?) in
      
      if let weatherData = results {
        let wData = weatherData
        
        DispatchQueue.main.async {
          self.setLandingPageInfo(location: location, wData: wData)
        }
        
      }
      
    })
    
  }
}


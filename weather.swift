//
//  weather.swift
//  Assignment2
//
//  Created by Ankit Shah on 2019-12-04.
//  Copyright © 2019 Ankit Shah. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
  let latitude: Double
  let longitude: Double
  let timezone: String
  let currently: Currently
  let daily: Daily
}

struct Currently: Decodable {
  let time: Double
  let summary: String
  let icon: String
  let temperature: Double
  let apparentTemperature: Double
  let humidity: Double
  let pressure: Double
  let windSpeed: Double
  let windBearing: Float
}

struct Data: Decodable {
  let time: Double
  let summary: String
  let icon: String
  let temperatureMax: Double
  let temperatureMin: Double
  let sunriseTime: Double
  let sunsetTime: Double
  let humidity: Float
  let pressure: Double
  let windSpeed: Double
  let windBearing: Float
}

struct Daily: Decodable{
  let summary: String
  let icon: String
  let data: [Data]
}
class Weather {
  
  // API for Weather forecasting
  static let api_path = "https://api.darksky.net/forecast/add3671fffda51ccfe4b852aefb7ed74/"
  
  // converting wind degree to specific direction
  func windDirectionFromDegrees(degrees : Float) -> String {
    
    let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    let i: Int = Int((degrees + 11.25)/22.5)
    return directions[i % 16]
  }
  
  // converting unix time(epoch) to system time
  func convertUnixTimeToLocalTime(unixTime: Double) -> String {
    let date = Date(timeIntervalSince1970: unixTime)
    
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "hh:mm a"
    
    let dateString = dayTimePeriodFormatter.string(from: date)
    
    return dateString
  }
  
  // decoding weather api to populate application's structs
  func decodingWeatherApi(location: LocationInformation, urlString: String, completion: @escaping (WeatherData?) -> ()) {
    var wData: WeatherData?
    //    let l = location
    let urlSession = URLSession(configuration: .default)
    if let url = URL(string: urlString) {
      
      let task =
        urlSession.dataTask(with: url) { (data, response, error) in
          if let data = data {
            let decoder = JSONDecoder()
            do {
              wData = try
                decoder.decode(WeatherData.self, from: data)
              //self.setLandingPageInfo(location: l, wData: wData)
            }
            catch{
              print(error.localizedDescription)
              print("I can not decode your data")
            }
            completion(wData!)
          }
      }
      task.resume()
    }
  }
  // generating API url for passing it to decodingWeatherApi() method
  func fetchApiDetails(location: LocationInformation) -> String {
    let l = location
    let locationString = Weather.api_path + String(format:"%f", l.latitude!) + "," + String(format:"%f", l.longitude!)
    
    let urlString = locationString + "?units=si&exclude=minutely,hourly,alerts,flags"
    
    return urlString
    
  }
}

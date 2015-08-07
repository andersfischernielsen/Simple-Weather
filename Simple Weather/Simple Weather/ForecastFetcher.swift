//
//  ForecastFetcher.swift
//  Simple Weather
//
//  Created by Eva Fischer-Nielsen on 22/07/15.
//  Copyright (c) 2015 Anders Fischer-Nielsen. All rights reserved.
//

import UIKit

class ForecastFetcher: NSObject {
    
    func fetchForCoordinatesWithLatitude(latitude: Double, longitude: Double) -> (String, [HourWeatherData])? {
        let timestamp = Int(NSDate().timeIntervalSince1970) - 10800
        
        if let json = getJSON("https://api.forecast.io/forecast/c8b21df3eeb39178cc1d49d6f760f251/\(latitude),\(longitude),\(timestamp)?units=si") {
            let asDictionary = parseJSON(json)
            let weatherDescription = getWeatherDescription(asDictionary)
            let hourlyWeatherData = getHourlyWeatherData(asDictionary)
            
            return (weatherDescription, hourlyWeatherData)
        }
        
        else {
            return nil
        }
    }
    
    private func getJSON(urlToRequest: String) -> NSData? {
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)
    }
    
    private func parseJSON(inputData: NSData) -> Dictionary<String, AnyObject> {
        var error: NSError?
        let weatherData = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        
        return weatherData as! Dictionary<String, AnyObject>
    }
    
    private func getWeatherDescription(data: Dictionary<String, AnyObject>) -> String {
        let hourly = data["hourly"] as! Dictionary<String, AnyObject>
        let description = hourly["summary"] as! String
        return "\(description)"
    }
    
    private func getHourlyWeatherData(data: Dictionary<String, AnyObject>) -> [HourWeatherData] {
        let hourly = data["hourly"] as! Dictionary<String, AnyObject>
        let data = hourly["data"] as! [AnyObject]
        var asHourData: [HourWeatherData] = []
        
        for forecast in data {
            if let parsed = sortByHourAndConvertToWeatherData(forecast) {
                asHourData.append(parsed)
            }
        }
        
        return asHourData
    }
    
    private func sortByHourAndConvertToWeatherData(forecast: AnyObject) -> HourWeatherData? {
        let time = NSDate(timeIntervalSince1970: NSTimeInterval(forecast["time"] as! Int))
        let interval = time.timeIntervalSinceNow
        
        //if interval <= 7200 && interval >= 0 || interval >= -7200 && interval <= 0 {
            let icon = forecast["icon"] as! String
            let forecastTime = NSDate(timeIntervalSince1970: NSTimeInterval(forecast["time"] as! Int))
            let temperature = forecast["temperature"] as! Double
            let precipation = forecast["precipIntensity"] as? Double
            
            return HourWeatherData(icon: icon, time: forecastTime, temperature: temperature, precipation: precipation)
        //}
        //else {
        //    return nil
        //}
    }
}

class HourWeatherData {
    var icon: String = ""
    var time: NSDate
    var temperature: Double = 0.0
    var precipation: Double = 0.0
    
    init(icon: String, time: NSDate, temperature: Double, precipation: Double?) {
        self.icon = icon
        self.time = time
        self.temperature = temperature
        if let prec = precipation {
            self.precipation = prec
        }
    }
}
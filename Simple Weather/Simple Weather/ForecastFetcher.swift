//
//  ForecastFetcher.swift
//  Simple Weather
//
//  Created by Eva Fischer-Nielsen on 22/07/15.
//  Copyright (c) 2015 Anders Fischer-Nielsen. All rights reserved.
//

import UIKit

class ForecastFetcher: NSObject {
    var data : NSArray = []
    var weatherDescription = String()
    var hourlyWeatherData: [HourWeatherData] = []
    
    override init() {
        super.init()
        let json = getJSON("file:///Users/iMac/Desktop/SimpleWeather/forecast.json")
        let asDictionary = parseJSON(json)
        weatherDescription = getWeatherDescription(asDictionary)
        hourlyWeatherData = getHourlyWeatherData(asDictionary)
    }
    
    func getJSON(urlToRequest: String) -> NSData {
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func getWeatherDescription(data: Dictionary<String, AnyObject>) -> String {
        let hourly = data["hourly"] as! Dictionary<String, AnyObject>
        return hourly["summary"] as! String
    }
    
    func getHourlyWeatherData(data: Dictionary<String, AnyObject>) -> [HourWeatherData] {
        let hourly = data["hourly"] as! Dictionary<String, AnyObject>
        let data = hourly["data"] as! [AnyObject]
        var asHourData: [HourWeatherData] = []
        
        for forecast in data {
            if let parsed = parseToHourWeatherData(forecast) {
                asHourData.append(parsed)
            }
        }
        
        return asHourData
    }
    
    func parseToHourWeatherData(forecast: AnyObject) -> HourWeatherData? {
        let time = NSDate(timeIntervalSince1970: NSTimeInterval(forecast["time"] as! Int))
        let interval = time.timeIntervalSinceNow
        
        if interval < 7200 && interval > 0 || interval > -7200 && interval < 0 {
            let icon = forecast["icon"] as! String
            let time = NSDate(timeIntervalSince1970: NSTimeInterval(forecast["time"] as! Int))
            let temperature = forecast["temperature"] as! Double
            let precipation = forecast["precipation"] as? Double
            
            return HourWeatherData(icon: icon, time: time, temperature: temperature, precipation: precipation)
        }
        else {
            return nil
        }
    }
    
    func parseJSON(inputData: NSData) -> Dictionary<String, AnyObject> {
        var error: NSError?
        let weatherData = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        
        return weatherData as! Dictionary<String, AnyObject>
    }
    
    
    
    func convertToNSDate(toConvertAndCompare: Int) -> NSDate {
        var timestamp = NSTimeInterval(toConvertAndCompare)
        
        return NSDate(timeIntervalSince1970:timestamp)
    }
    
    func dateIsIn5HourInterval(toCompare: NSDate) -> Bool {
        return toCompare.timeIntervalSinceNow < 7200
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
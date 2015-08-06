//
//  ViewController.swift
//  Simple Weather
//
//  Created by Eva Fischer-Nielsen on 22/07/15.
//  Copyright (c) 2015 Anders Fischer-Nielsen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var forecastSummary: UILabel!
    
    @IBOutlet weak var firstTimeLabel: UILabel!
    @IBOutlet weak var secondTimeLabel: UILabel!
    @IBOutlet weak var thirdTimeLabel: UILabel!
    @IBOutlet weak var fourthTimeLabel: UILabel!
    @IBOutlet weak var fifthTimeLabel: UILabel!
    
    @IBOutlet weak var firstImageLabel: UIImageView!
    @IBOutlet weak var secondImageLabel: UIImageView!
    @IBOutlet weak var thirdImageLabel: UIImageView!
    @IBOutlet weak var fourthImageLabel: UIImageView!
    @IBOutlet weak var fifthImageLabel: UIImageView!
    
    @IBOutlet weak var firstTempLabel: UILabel!
    @IBOutlet weak var secondTempLabel: UILabel!
    @IBOutlet weak var thirdTempLabel: UILabel!
    @IBOutlet weak var fourthTempLabel: UILabel!
    @IBOutlet weak var fifthTempLabel: UILabel!
    
    @IBOutlet weak var firstHeight: NSLayoutConstraint!
    @IBOutlet weak var secondHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdhHeight: NSLayoutConstraint!
    @IBOutlet weak var fourthHeight: NSLayoutConstraint!
    @IBOutlet weak var fifthHeight: NSLayoutConstraint!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
    }

    private func setViewDataFromCoordinates(lat: Double, lon: Double) {
        let times = [firstTimeLabel, secondTimeLabel, thirdTimeLabel, fourthTimeLabel, fifthTimeLabel]
        var images = [firstImageLabel, secondImageLabel, thirdImageLabel, fourthImageLabel, fifthImageLabel]
        let temps = [firstTempLabel, secondTempLabel, thirdTempLabel, fourthTempLabel, fifthTempLabel]
        let constraints = [firstHeight, secondHeight, thirdhHeight, fourthHeight, fifthHeight]
        
        let fetcher = ForecastFetcher()
        
            if let weatherData = fetcher.fetchForCoordinatesWithLatitude(lat, longitude: lon) {
                let summary = weatherData.0
                let data = weatherData.1 as [HourWeatherData]!
                
                forecastSummary.text = summary
                
                var i = 0
                for forecast in data {
                    times[i].text = getPrintDate(data[i].time)
                    images[i].image = UIImage(named: forecast.icon)
                    temps[i].text = String(format: "%.1f", forecast.temperature) + " °C"
                    constraints[i].constant = CGFloat(200 * forecast.precipation)
                    i += 1
                }
        }
    }
    
    private func getPrintDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: date)
        let hour = comp.hour
        let minute = comp.minute
        
        if minute == 0 {
            return "\(hour):\(minute)\(minute)"
        }
        else {
            return "\(hour):\(minute)"
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as! CLLocation
            var coord = locationObj.coordinate
        
            setViewDataFromCoordinates(coord.latitude as Double, lon: coord.longitude as Double)
        }
}


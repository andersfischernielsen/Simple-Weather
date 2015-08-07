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
    
    var locationManager: CLLocationManager?
    var oldCoords: (Double, Double) = (0.0, 0.0)
    
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
        for child in self.childViewControllers {
            if child.isKindOfClass(WeatherTableViewController) {
                let controller = child as! WeatherTableViewController
                
                if let (summary, data) = self.fetchForecastData(lat, lon: lon) {
                    forecastSummary.text = summary
                    controller.setTableViewData(data)
                }
            }
            
        }
    }
    
    private func fetchForecastData(lat: Double, lon: Double) -> (String, [HourWeatherData])? {
        let fetcher = ForecastFetcher()
        return fetcher.fetchForCoordinatesWithLatitude(lat, longitude: lon)
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locationObj = (locations as NSArray).lastObject as! CLLocation
        var coord = locationObj.coordinate
        
        let lat = coord.latitude as Double
        let lon = coord.longitude as Double
        
        if (lat != oldCoords.0 && lon != oldCoords.1) {
            setViewDataFromCoordinates(coord.latitude as Double, lon: coord.longitude as Double)
            oldCoords = (lat, lon)
        }
    }
}


//
//  WeatherTableViewController.swift
//  Simple Weather
//
//  Created by Anders Fischer-Nielsen on 07/08/15.
//  Copyright (c) 2015 Anders Fischer-Nielsen. All rights reserved.
//

import Foundation
import UIKit

class WeatherTableViewController: UITableViewController {
    
    let data = [
        HourWeatherData(icon: "test", time: NSDate(), temperature: 20.0, precipation: nil),
        HourWeatherData(icon: "test", time: NSDate(), temperature: 20.0, precipation: nil),
        HourWeatherData(icon: "test", time: NSDate(), temperature: 20.0, precipation: nil),
        HourWeatherData(icon: "test", time: NSDate(), temperature: 20.0, precipation: nil),
        HourWeatherData(icon: "test", time: NSDate(), temperature: 20.0, precipation: nil)
    ]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as! WeatherTableViewCell
        let entry = data[indexPath.row]
        
        cell.iconImage.image = UIImage(named: entry.icon)
        cell.timeLabel.text = entry.time
        cell.tempLabel.text = entry.temperature
        
        //times[i].text = getPrintDate(data[i].time)
        //images[i].image = UIImage(named: forecast.icon)
        //temps[i].text = String(format: "%.1f", forecast.temperature) + " °C"
        //constraints[i].constant = CGFloat(200 * forecast.precipation)
        
        return cell
    }
}

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
}
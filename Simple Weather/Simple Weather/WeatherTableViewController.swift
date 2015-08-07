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
    
    var data: [HourWeatherData] = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func setTableViewData(toSetWith: [HourWeatherData]) {
        data = toSetWith
        let table = self.view as! UITableView
        table.reloadData()
        table.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI * 0.5));
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as! WeatherTableViewCell
        let forecast = data[indexPath.row]
        
        cell.iconImage.image = UIImage(named: forecast.icon)
        cell.timeLabel.text = getPrintDate(forecast.time)
        cell.tempLabel.text = String(format: "%.1f", forecast.temperature) + " °C"
        cell.precipationConstraint.constant = CGFloat(200 * forecast.precipation)
        
        return cell
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
    
    
}

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var precipationConstraint: NSLayoutConstraint!
}
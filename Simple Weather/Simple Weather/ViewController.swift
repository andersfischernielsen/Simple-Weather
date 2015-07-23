//
//  ViewController.swift
//  Simple Weather
//
//  Created by Eva Fischer-Nielsen on 22/07/15.
//  Copyright (c) 2015 Anders Fischer-Nielsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var forecastSummary: UILabel!
    
    @IBOutlet weak var firstTimeLabel: UILabel!
    @IBOutlet weak var secondTimeLabel: UILabel!
    @IBOutlet weak var thirdTimeLabel: UILabel!
    @IBOutlet weak var fourthTimeLabel: UILabel!
    @IBOutlet weak var fifthTimeLabel: UILabel!
    
    @IBOutlet weak var firstImageLabel: UILabel!
    @IBOutlet weak var secondImageLabel: UILabel!
    @IBOutlet weak var thirdImageLabel: UILabel!
    @IBOutlet weak var fourthImageLabel: UILabel!
    @IBOutlet weak var fifthImageLabel: UILabel!
    
    @IBOutlet weak var firstTempLabel: UILabel!
    @IBOutlet weak var secondTempLabel: UILabel!
    @IBOutlet weak var thirdTempLabel: UILabel!
    @IBOutlet weak var fourthTempLabel: UILabel!
    @IBOutlet weak var fifthTempLabel: UILabel!
    
    override func viewDidLoad() {

        let times = [firstTimeLabel, secondTimeLabel, thirdTimeLabel, fourthTimeLabel, fifthTimeLabel]
        let images = [firstImageLabel, secondImageLabel, thirdImageLabel, fourthImageLabel, fifthImageLabel]
        let temps = [firstTempLabel, secondTempLabel, thirdTempLabel, fourthTempLabel, fifthTempLabel]
        
        super.viewDidLoad()
        
        let fetcher = ForecastFetcher()
        
        if let description = fetcher.weatherDescription {
            forecastSummary.text = fetcher.weatherDescription
        }
        
        if let data = fetcher.hourlyWeatherData {
            var i = 0
            for forecast in data {
                times[i].text = getPrintDate(data[i].time)
                images[i].text = forecast.icon
                temps[i].text = "\(forecast.temperature)°"
                i += 1
            }
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getPrintDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: date)
        let hour = comp.hour
        let minute = comp.minute
        
        return "\(hour):\(minute)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


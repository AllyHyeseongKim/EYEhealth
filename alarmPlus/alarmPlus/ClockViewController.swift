//
//  ViewController.swift
//  HGCircularSlider
//
//  Created by Hamza Ghazouani on 10/19/2016.
//  Copyright (c) 2016 Hamza Ghazouani. All rights reserved.
//

import UIKit
import HGCircularSlider
import UserNotifications

extension Date {
    
}

@available(iOS 10.0, *)
class ClockViewController: UIViewController {
    let timeSelector: Selector = #selector(ClockViewController.updateTime)
    let interval = 1.0
    var count = 0
    
    
    
    
    
    
    var selectTime = Date()
    var intervalTime:TimeInterval = 0.0
    var mainDate = Date()
    let content = UNMutableNotificationContent()
    let center = UNUserNotificationCenter.current()
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var bedtimeLabel: UILabel!
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var rangeCircularSlider: RangeCircularSlider!
    @IBOutlet weak var clockFormatSegmentedControl: UISegmentedControl!
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        
        center.requestAuthorization(options: [.alert,.sound]) {
            (granted, error) in
        }
        
        
        content.title = "설정하신 시간이 되었습니다"
        content.body = "렌즈를 탈착해주세요"
        
        // setup O'clock
        rangeCircularSlider.startThumbImage = UIImage(named: "Bedtime")
        rangeCircularSlider.endThumbImage = UIImage(named: "Wake")
        
        let dayInSeconds = 24 * 60 * 60
        rangeCircularSlider.maximumValue = CGFloat(dayInSeconds)
        
        rangeCircularSlider.startPointValue = 1 * 60 * 60
        rangeCircularSlider.endPointValue = 8 * 60 * 60
        
        updateTexts(rangeCircularSlider)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateTexts(_ sender: AnyObject) {
        
        adjustValue(value: &rangeCircularSlider.startPointValue)
        adjustValue(value: &rangeCircularSlider.endPointValue)
        
        // 오늘 날짜 0시 0분 구하기
        var findTodayDate = Date()
        var todayDateFormatter = DateFormatter()
        todayDateFormatter.dateFormat = "YYYY-MM-dd"
        var stringDate = todayDateFormatter.string(from: findTodayDate)
        var today = todayDateFormatter.date(from: stringDate)
        var koreaToday = today! + 60*60*9
        //print(koreaToday)
        //2001년 1월 1일 0시 0분
        let twoFormatter = DateFormatter()
        twoFormatter.locale = Locale(identifier:"en_US")
        twoFormatter.dateFormat = "yyyy-MM-dd"
        let xTime = twoFormatter.date(from: "2001-01-01")
        
        
        let bedtime = TimeInterval(rangeCircularSlider.startPointValue)
        let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
        bedtimeLabel.text = dateFormatter.string(from: bedtimeDate)
        
        let wake = TimeInterval(rangeCircularSlider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
        
        var forTodayInternal = wakeDate.timeIntervalSince(today!)
        
        var hourinternal = wakeDate.timeIntervalSince(xTime!)
        selectTime = Date(timeInterval: hourinternal, since: today!)
        //print(selectTime)
        
        wakeLabel.text = dateFormatter.string(from: wakeDate)
        
        let duration = wake - bedtime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        dateFormatter.dateFormat = "HH:mm"
        durationLabel.text = dateFormatter.string(from: durationDate)
        dateFormatter.dateFormat = "hh:mm a"
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
    
    @objc func updateTime() {
        //        lblCurrentTime.text = String(count)
        //        count = count + 1
        
        //        let date = NSDate()
        //        nowTime = date as Date
        var nowTime = Date() + 60*60*9
        //print(selectTime)
        intervalTime = selectTime.timeIntervalSince(nowTime)
        print(intervalTime)
        //print(nowTime)
        //print(mainDate)
        mainDate = Date().addingTimeInterval(intervalTime)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],from: mainDate)
        
        if #available(iOS 10.0, *) {
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let uuidString = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: uuidString,content: content,trigger: trigger)
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            
            center.add(request) { (error) in
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
        
    }
}


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
    var startTime = Date()
    var intervalTime:TimeInterval = 0.0
    var mainDate = Date()
    let content = UNMutableNotificationContent()
    let center = UNUserNotificationCenter.current()
    
    
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var bedtimeLabel: UILabel!
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var rangeCircularSlider: RangeCircularSlider!
    @IBOutlet weak var clockFormatSegmentedControl: UISegmentedControl!
    @IBOutlet weak var recommendTime: UILabel!
    @IBOutlet weak var switchSquere: UIView!
    @IBOutlet weak var lensOnOffLable: UILabel!
    
    var isOn = false
    
    var recommend = 8
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           
        
        
        
        recommendTime.text = "\(recommend)hour"
        
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
        
        rangeCircularSlider.startPointValue = 8 * 60 * 60
        rangeCircularSlider.endPointValue = 16 * 60 * 60
        
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
        var startinternal = bedtimeDate.timeIntervalSince(xTime!)
        selectTime = Date(timeInterval: hourinternal, since: today!)
        //print(selectTime)
        
        startTime = Date(timeInterval: startinternal, since: today!)
        
        wakeLabel.text = dateFormatter.string(from: wakeDate)
        
        
        
        let duration = wake - bedtime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        if Int(duration)>60*60*8 {
            recommendTime.textColor = UIColor.red
        } else {
            recommendTime.textColor = UIColor.gray
        }
        dateFormatter.dateFormat = "HH:mm"
        
        dateFormatter.dateFormat = "hh:mm a"
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
    
    @objc func updateTime() {
        
        DataCenter.sharedInstnce.timeList.append(timeInfo(selectTime: selectTime, startTime: startTime))
     //   for i in DataCenter.sharedInstnce.timeList
      //  {
        
    
   //     }
      
        
        //        lblCurrentTime.text = String(count)
        //        count = count + 1
        
        //        let date = NSDate()
        //        nowTime = date as Date
        var nowTime = Date() + 60*60*9
        //print(selectTime)
        
        //얼마나 지났는지 측정하기
        var durationInterval = nowTime.timeIntervalSince(startTime)
        var durationHour = Int(durationInterval/3600)
        var durationMin = Int((Int(durationInterval) / 60) % 60)
        if(durationHour>=recommend && durationMin>0) {
            durationLabel.textColor = UIColor.red
        }
        else {
            durationLabel.textColor = UIColor.white
        }
        if(durationMin<0) {
            durationLabel.text = "--:--"
        }
        else {
            if(durationHour<10) {
                if(durationMin<10) {
                    durationLabel.text = "0\(durationHour):0\(durationMin)"
                }
                else {durationLabel.text = "0\(durationHour):\(durationMin)"
                }
            }
            else if(durationMin<10) {
                durationLabel.text = "\(durationHour):0\(durationMin)"
            }
            else {
                durationLabel.text = "\(durationHour):\(durationMin)"
            }
        }
        intervalTime = selectTime.timeIntervalSince(nowTime)
        //print(intervalTime)
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
    @IBAction func switchOnOff(_ sender: UISwitch) {
        
        let scale:CGFloat = 100.0
        
        var newHeight:CGFloat
        
        if(isOn) {
            lensOnOffLable.text = "Lens On"
            newHeight = switchSquere.frame.height/scale
            switchSquere.frame.size = CGSize(width: switchSquere.frame.width, height: newHeight)
        }
        else {
            lensOnOffLable.text = "Lens Off"
            newHeight = switchSquere.frame.height*scale
            switchSquere.frame.size = CGSize(width: switchSquere.frame.width, height: newHeight)
        }
        isOn = !isOn
    }
}


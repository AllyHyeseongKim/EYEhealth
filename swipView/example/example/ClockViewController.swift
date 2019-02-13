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
class ClockViewController: UIViewController, ClockViewDelegateProtocol {
      
   
    //추가- 데이터저장
    var times: [Time] = []
    //
    
    var selectTime = Date()
    var startTime = Date()
    var intervalTime:TimeInterval = 0.0
    var mainDate = Date()
    let content = UNMutableNotificationContent()
    let center = UNUserNotificationCenter.current()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        
        center.requestAuthorization(options: [.alert,.sound]) {
            (granted, error) in
        }
        
        
        content.title = "설정하신 시간이 되었습니다"
        content.body = "렌즈를 탈착해주세요"
        
        appDelegate.AppContent = content
        appDelegate.AppCenter = center
        //추가-데이터 저장
        appDelegate.delegate = self
        //
        
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
        
        var wake = TimeInterval(rangeCircularSlider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
        
        var forTodayInternal = wakeDate.timeIntervalSince(today!)
        
        var hourinternal = wakeDate.timeIntervalSince(xTime!)
        var startinternal = bedtimeDate.timeIntervalSince(xTime!)
        selectTime = Date(timeInterval: hourinternal, since: today!)
        //print(selectTime)
        
        
        appDelegate.AppSelectTime = selectTime
        
        startTime = Date(timeInterval: startinternal, since: today!)
        
        wakeLabel.text = dateFormatter.string(from: wakeDate)
        
        if(wake < bedtime) {
            wake = wake + 60*60*24
            selectTime = selectTime + 60*60*24
        }
        
        let duration = wake - bedtime
        
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        if Int(duration)>60*60*8 {
            durationLabel.textColor = UIColor.red
        } else {
            durationLabel.textColor = UIColor.white
        }
        //print(startTime)
        recommendTime.textColor = UIColor.gray
        
        dateFormatter.dateFormat = "HH:mm"
        durationLabel.text = dateFormatter.string(from: durationDate)
        dateFormatter.dateFormat = "hh:mm a"
        
        
        //시간 저장
       
        times.append(Time(todayDate: startTime,
                          startTime: startTime,
                          selectTime: selectTime,
                          recommendTime: recommend,
                          duration: duration,
                          lensOn: true))
        
        
    }
    
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
    
    
    
    //데이터 저장
    func getDocumentDirPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    func saveTimes(times:[Time]) {
        let documentDirPath = getDocumentDirPath().appendingPathComponent("times.arr")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: times, requiringSecureCoding: false)
            try data.write(to: documentDirPath)
            //print("save!!!!!!!")
        } catch {
            //print("Error!")
        }
    }
    
    func loadTimes() -> [Time]? {
        let documentDirPath = getDocumentDirPath().appendingPathComponent("times.arr")
        
        //print("로드 함수 안 입니다~~ 잘 들어오네요")
        
        
        do {
            let data = try Data(contentsOf: documentDirPath)
            if let timesArr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Time] {
                return timesArr
                
            }
             //print("load!!!!!!!")
        } catch {
            //print("Error!")
        }
        return nil
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


//
//  TimeInfo.swift
//  example
//
//  Created by CAU on 10/02/2019.
//  Copyright © 2019 fjae. All rights reserved.
//

import Foundation
import UIKit

class Time: NSObject, NSCoding {
    
    
    var todayDate: Date
    var startTime: Date
    var selectTime: Date
    var recommendTime: Int
    var duration: Double
    var lensOn: Bool
    
    // 1
    init(todayDate: Date, startTime: Date, selectTime: Date, recommendTime: Int, duration: Double, lensOn: Bool) {
        self.todayDate = todayDate
        self.startTime = startTime
        self.selectTime = selectTime
        self.recommendTime = recommendTime
        self.duration = duration
        self.lensOn = lensOn
    }
    
    //코드 중복이 이루어지지않아서 초기화가 편하다!! 수정이 편하다!
    //    convenience init(title:String) {
    //        self.init(title: title,writer: "",publisher: "",coverImage: nil,note: "",rate: 0)
    //    }
    
    func encode(with aCode: NSCoder) {
        aCode.encode(self.todayDate, forKey: "todayDate")
        aCode.encode(self.startTime, forKey: "startTime")
        aCode.encode(self.selectTime, forKey: "selectTime")
        aCode.encode(self.recommendTime, forKey: "recommendTime")
        aCode.encode(self.duration, forKey: "duration")
        aCode.encode(self.lensOn, forKey: "lensOn")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.todayDate = aDecoder.decodeObject(forKey: "todayDate") as! Date
        self.startTime = aDecoder.decodeObject(forKey: "startTime") as! Date
        self.selectTime = aDecoder.decodeObject(forKey: "selectTime") as! Date
        self.recommendTime = aDecoder.decodeInteger(forKey: "recommendTime") as! Int
        self.duration = aDecoder.decodeDouble(forKey: "duration") as! Double
        self.lensOn = aDecoder.decodeBool(forKey: "lensOn") as! Bool
    }
    
}

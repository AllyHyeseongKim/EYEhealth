//
//  TimeInfo.swift
//  example
//
//  Created by CAU on 10/02/2019.
//  Copyright © 2019 fjae. All rights reserved.
//

import Foundation


class timeInfo:NSObject, NSCoding {
    
    var selectTime:Date
    var startTime:Date
 
    
    
    init(selectTime:Date, startTime:Date) {
        self.selectTime = selectTime
        self.startTime = startTime
       
        
    }
    required init?(coder aDecoder: NSCoder) {
        self.selectTime = aDecoder.decodeObject(forKey: "selectTime") as! Date
        self.startTime = aDecoder.decodeObject(forKey: "startTime") as! Date
       
       
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.selectTime, forKey: "selectTime")
        aCoder.encode(self.startTime, forKey: "startTime")
    
       
    }
}

//
//  DataCenter.swift
//  example
//
//  Created by CAU on 10/02/2019.
//  Copyright © 2019 fjae. All rights reserved.
//

import Foundation

class DataCenter{
    static let sharedInstnce = DataCenter()
    var timeList:[timeInfo] = []
    
    
    func save() {
        let encodeDate = NSKeyedArchiver.archivedData(withRootObject: timeList)
        UserDefaults.standard.setValue(encodeDate, forKey: "timeList")
        print(DataCenter.sharedInstnce.timeList[0])
    }
    
    func load() {
        guard let encodeDate = UserDefaults.standard.value(forKeyPath: "timeList") as? Data else { return }
        self.timeList = NSKeyedUnarchiver.unarchiveObject(with: encodeDate) as! [timeInfo]
}
}

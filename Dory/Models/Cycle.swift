//
//  Cycle.swift
//  Dory
//
//  Created by itay gervash on 27/08/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import Foundation
import RealmSwift

class Cycle: Object {
    
    var calendar = Calendar.current
    var now = Date()
    
    
    @objc dynamic var state: Int = 1
    
    @objc dynamic var startDate: Date?
    @objc dynamic var expectedRemovalDate: Date?
    @objc dynamic var removalDate: Date?
    @objc dynamic var expectedEndDate: Date?
    @objc dynamic var endDate: Date?
    
    public func initiateCycle(withStart date: Date) -> Cycle {
        let cycle = Cycle()
        
        cycle.startDate = date
        cycle.expectedRemovalDate = calendar.date(byAdding: .weekOfYear, value: 3, to: date)
        cycle.expectedEndDate = calendar.date(byAdding: .weekOfYear, value: 4, to: date)
        cycle.state = 1
        
        return cycle
    }
    
}

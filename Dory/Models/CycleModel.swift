//
//  CycleModel.swift
//  Dory
//
//  Created by itay gervash on 02/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import RealmSwift

let updateParametersNotificationKey = "com.gervash.updateParameters"
let updateParametersNotificationName = Notification.Name(updateParametersNotificationKey)

class CycleModel {
    
    private let realm = try! Realm()
    
    private var calendar = Calendar.current
    private var dateFormatter = DateFormatter()
    var now = Date() {
        didSet {
            NotificationCenter.default.post(name: updateParametersNotificationName, object: nil)
        }
    }
    
    var cycles: Results<Cycle>?
    var currentCycle: Cycle?
    
    var daysInside: Int?
    var daysOutside: Int?
    var daysToAction: Int? {
        didSet {
            if daysToAction != nil {
                if daysToAction! < 0 {
                    daysToAction = 0
                }
            }
        }
    }
    
    var cyclePartLength: Int?
    
    var nextAction: nextAction?
    
    init() {
        
        cycles = getCyclesFromRealm()
        currentCycle = cycles?.last
        setParameters()

        NotificationCenter.default.addObserver(self, selector: #selector(setParameters), name: updateParametersNotificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    
    @objc func setParameters() {
        guard currentCycle != nil else { return }
        
        checkForAwaitingRemoval()
        
        if currentCycle!.state == 1 || currentCycle!.state == 0 {
            daysInside =  numberOfDays(between: now, and: currentCycle?.startDate)
            daysOutside = nil
            cyclePartLength = 21
            self.nextAction = .remove
        } else {
            daysOutside = numberOfDays(between: now, and: currentCycle?.removalDate)
            daysInside = numberOfDays(between: currentCycle?.removalDate, and: currentCycle?.startDate)
            self.nextAction = .insert
            cyclePartLength = 7
        }
        
        getDaysToAction(from: self.currentCycle)
    }
    
    func getDaysToAction(from cycle: Cycle?) {
        
        guard cycle != nil else { return }
        
        if cycle!.state == 1 {
            daysToAction = numberOfDays(between: now, and: cycle!.expectedRemovalDate)! + 1
        }
        
        else if cycle!.state == 0 {
            daysToAction = 0
        }
        
        else if cycle!.state == -1 {
            daysToAction = numberOfDays(between: now, and: cycle!.expectedEndDate)
        }
    }
    
    func checkForAwaitingRemoval() {
        guard currentCycle != nil && currentCycle?.expectedRemovalDate != nil else { return }
        
        let startOfToday = calendar.dateInterval(of: .day, for: now)?.start
        let dayOfRemoval = calendar.dateInterval(of: .day, for: (currentCycle?.expectedRemovalDate)!)?.start
        
        guard startOfToday != nil, dayOfRemoval != nil else { return }
        
        if startOfToday! >= dayOfRemoval! {
            do {
                try realm.write {
                    currentCycle?.state = 0
                    currentCycle?.expectedRemovalDate = Date()
                    currentCycle?.expectedEndDate = calendar.date(byAdding: .day, value: 7, to: currentCycle?.expectedRemovalDate ?? Date())
                }
            } catch {
                print("error in realm write transaction:", error)
            }
        }
    }
    
    func changeRingState(to newState: Int) {
        
        do {
            try realm.write {
                currentCycle?.state = newState
            }
        } catch {
            print("error writing to realm \(error)")
        }
    }
    
    func startNewCycle() {
        
        let newCycle = Cycle().initiateCycle(withStart: Date())
        
        do {
            try realm.write {
                currentCycle?.endDate = Date()
                realm.add(newCycle)
            }
        } catch { print("error writing to realm \(error)") }
        
        currentCycle = cycles?.last
    }

    func numberOfDays(between start: Date?, and end: Date?) -> Int? {
        
        guard start != nil && end != nil else { return nil }
        
        let interval =  calendar.dateComponents([.day], from: start!, to: end!)
        
        return interval.day
    }
    
    func getCyclesFromRealm() -> Results<Cycle> {
        return realm.objects(Cycle.self)
        
    }
    
    enum nextAction: String {
        case insert = "insert"
        case remove = "remove"
    }
    
}

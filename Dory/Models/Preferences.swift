//
//  Preferences.swift
//  Dory
//
//  Created by itay gervash on 05/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import Foundation
import RealmSwift

class Preferences: Object {
    

    @objc dynamic var name: String = "Dory"
    @objc dynamic var proVersion: Bool = false
    
    dynamic var notificationHour: Int? = nil
    dynamic var notificationMinute: Int? = nil
    
    @objc dynamic var prescriprionNotification: Bool = false
    
    dynamic var prescriptionNotificationHour: Int? = nil
    dynamic var prescriptionNotificationMinute: Int? = nil
    
}

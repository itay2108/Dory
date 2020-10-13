//
//  DateLAbel.swift
//  Dory
//
//  Created by itay gervash on 13/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit

class DateLabel: UILabel {
    
    var fontTypes = FontTypes()

    var state: labelState? {
        didSet {
            if state == .text { self.textColor = .lightGray }
            else { self.textColor = K.colors.gunmetal }
        }
    }
    
    override var text: String? {
        didSet {
            if text == "" || text == nil { state = .empty }
            else { state = .text }
        }
    }

}


enum labelState {
    case placeHolder
    case text
    case empty
}

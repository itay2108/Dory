//
//  UIView+Extensions.swift
//  Dory
//
//  Created by itay gervash on 03/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit

public extension UIView {
    
    func circlize() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func uncirclize() {
        
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
        
    }
    
    func shadow(color: UIColor, radius: CGFloat, opacity: CGFloat, xOffset: CGFloat, yOffset: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
    }
    
    func addSubview(_ view: UIView, _ layout: (ConstraintMaker) -> Void) {
        addSubview(view)
        view.snp.makeConstraints(layout)
    }
    
}

extension Date {
    func asString(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func startOfDay() -> Date? {
        let calendar = Calendar.current
        return calendar.dateInterval(of: .day, for: self)?.start
    }
    
    func at(hour: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: self)
    }
}

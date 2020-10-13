//
//  DatePicker.swift
//  Dory
//
//  Created by itay gervash on 12/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit

public class DatePicker: UIView {
    
    private let heightModifier: CGFloat = UIScreen.main.bounds.size.height / 812
    private let widthModifier: CGFloat = UIScreen.main.bounds.size.width / 375
    
    private let fontTypes = FontTypes()
    
    var tint: UIColor? = K.colors.sizzlingRed {
        didSet {
            layoutAccessories()
        }
    }
    
    var detail = UIImageView(image: UIImage(systemName: "calendar")) {
        didSet {
            layoutAccessories()
        }
    }
    
    //button
    
    var trigger = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    
    //label
    
    lazy var dateLabel: DateLabel = {
        let label = DateLabel()
        label.text = "Insertion Date"
        label.font = fontTypes.h4_medium
        label.state = .placeHolder
        return label
    }()

    //main func to layout custom subviews
    
    private func layoutAccessories() {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.layer.cornerRadius = 8
        self.backgroundColor = K.colors.aliceBlue
        
        //add label
        
        self.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4 * heightModifier)
            make.bottom.equalToSuperview().offset(-4 * heightModifier)
            make.left.equalToSuperview().offset(14 * widthModifier)
            make.right.equalToSuperview().offset(-42 * widthModifier)
        }
        
        //add calendar image
        
        self.addSubview(detail)
        detail.contentMode = .scaleAspectFit
        detail.tintColor = tint ?? .blue
        
        detail.snp.makeConstraints { (make) in
            make.width.equalTo(16 * widthModifier)
            make.height.equalTo(16 * widthModifier)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-14 * widthModifier)
        }
        
        //add button to trigger action on tap
        self.addSubview(trigger)
        trigger.backgroundColor = .green
        
        trigger.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().priority(.high)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNeedsLayout()
        self.isUserInteractionEnabled = false
        layoutAccessories()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setNeedsLayout()
        self.isUserInteractionEnabled = false
        layoutAccessories()
    }

}

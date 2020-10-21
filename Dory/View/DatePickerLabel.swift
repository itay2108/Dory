//
//  DatePicker.swift
//  Dory
//
//  Created by itay gervash on 12/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit

public class DatePickerLabel: UIView {
    
    private let fontTypes = FontTypes()
    
    //view properties
    
    var tint: UIColor? = K.colors.sizzlingRed {
        didSet {
            detail.tintColor = tint
        }
    }
    
    //subviews
    
    lazy var trigger : UIButton = {
        return UIButton()
    }()

    
    lazy var dateLabel: OnboardingLabel = {
        let label = OnboardingLabel()
        label.text = "Insertion Date"
        label.font = fontTypes.h4_medium
        label.state = .placeHolder
        return label
    }()

    var detail: UIImageView = {
        let imgview = UIImageView()
        let image = UIImage(systemName: "calendar")
        imgview.contentMode = .scaleAspectFit
        guard image != nil else { return imgview }
        imgview.image = image
        imgview.tintColor = K.colors.sizzlingRed
        return imgview
    }()
    
    private func setUpView() {
        addSubviews()
        setConstraintsToSubviews()
    }
    
    private func addSubviews() {
        
        self.addSubview(dateLabel)
        self.addSubview(trigger)
        self.addSubview(detail)
        
    }
    
    //main func to layout custom subviews
    
    private func setConstraintsToSubviews() {

        self.layer.cornerRadius = 8
        self.backgroundColor = K.colors.aliceBlue
        
        //add label
        
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
        setUpView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setNeedsLayout()
        setUpView()
    }

}

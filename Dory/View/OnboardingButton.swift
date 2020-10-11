//
//  OnboardingButton.swift
//  Dory
//
//  Created by itay gervash on 01/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit
import SwiftFontName

class OnboardingButton: CRButton {

    let widthModifier: CGFloat = UIScreen.main.bounds.size.width / 375
    let fontTypes = FontTypes()

    func layoutAccessories() {
        layoutSubviews()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 14
        self.backgroundColor = K.colors.aliceBlue
        self.titleLabel?.font = fontTypes.button_bold
        self.tintColor = K.colors.gunmetal
        self.setTitleColor(K.colors.gunmetal, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNeedsLayout()
        layoutAccessories()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setNeedsLayout()
        layoutAccessories()
    }
    
    

}

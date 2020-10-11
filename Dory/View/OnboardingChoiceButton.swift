//
//  OnboardingChoiceButton.swift
//  Dory
//
//  Created by itay gervash on 11/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit
import SwiftFontName

class OnboardingChoiceButton: OnboardingButton {
    
    var choice = false
    
    override var isSelected: Bool {
        didSet {
            changeColors(animated: true)
        }
    }
    
    override func layoutAccessories() {
        super.layoutAccessories()
        
        self.layer.cornerRadius = 8
        self.titleLabel?.font = fontTypes.h3_demiBold
    }
    
    func changeColors(animated: Bool) {
        
        let duration: TimeInterval = animated ? 0.2 : 0
        
        UIView.animate(withDuration: duration) {
            if self.isSelected {
                self.backgroundColor = K.colors.sizzlingRed
                self.setTitleColor(K.colors.ghostWhite, for: .selected)
            } else {
                self.backgroundColor = K.colors.aliceBlue
                self.setTitleColor(K.colors.gunmetal, for: .normal)
            }
        }

    }
    
}

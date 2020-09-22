//
//  CRButton.swift
//  Dory
//
//  Created by itay gervash on 02/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit

@IBDesignable
class CRButton: UIButton {
    
    @IBInspectable var cornerRadius: Int = 4

    //MARK: - inits
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = false
        roundCorners()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = false
        roundCorners()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layer.masksToBounds = false
        roundCorners()

    }
    
    private func roundCorners() {
        self.layer.cornerRadius = CGFloat(cornerRadius)
    }

}

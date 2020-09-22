//
//  FontTypes.swift
//  Dory
//
//  Created by itay gervash on 06/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SwiftFontName

public class FontTypes {
    
    private let sizeModifier: CGFloat!
    
    var h1 = UIFont.systemFont(ofSize: 14)
    var h2 = UIFont.systemFont(ofSize: 14)
    var h2_medium = UIFont.systemFont(ofSize: 14)
    var h3 = UIFont.systemFont(ofSize: 14)
    var h3_medium = UIFont.systemFont(ofSize: 14)
    var h4_medium = UIFont.systemFont(ofSize: 13)
    var xl = UIFont.systemFont(ofSize: 14)
    
    init() {
        sizeModifier = UIScreen.main.bounds.size.height / 812
        
        h1 = UIFont(name: FontName.AvenirNextDemiBold, size: 23 * sizeModifier)!
        h2 = UIFont(name: FontName.AvenirNextRegular, size: 16 * sizeModifier)!
        h2_medium = UIFont(name: FontName.AvenirNextMedium, size: 16 * sizeModifier)!
        h3 = UIFont(name: FontName.AvenirNextRegular, size: 14 * sizeModifier)!
        h3_medium = UIFont(name: FontName.AvenirNextMedium, size: 14 * sizeModifier)!
        h4_medium = UIFont(name: FontName.AvenirNextMedium, size: 13 * sizeModifier)!
        xl = UIFont(name: FontName.AvenirNextDemiBold, size: 64 * sizeModifier)!
    }
    

    
}

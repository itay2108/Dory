//
//  BackButton.swift
//  Dory
//
//  Created by itay gervash on 10/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit

final class BackButton: UIButton {

    private var imageContainer: UIImageView = UIImageView()
    
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
    
    private func layoutAccessories() {
        
        self.addSubview(imageContainer)
        
        imageContainer.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let chevronImg = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30 * widthModifier, weight: .semibold))
        
        imageContainer.image = chevronImg
        
        imageContainer.contentMode = .scaleAspectFit
    }

}


//
//  MainMenuButton.swift
//  Dory
//
//  Created by itay gervash on 07/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit
import Then
import SwiftFontName

class MainMenuButton: UIButton {
    
    //        let heightModifier: CGFloat = UIScreen.main.bounds.size.height / 812
            let widthModifier: CGFloat = UIScreen.main.bounds.size.width / 375
    let fontTypes = FontTypes()
    
    var imageContainer: UIImageView!
    
    public var image: UIImage? = UIImage(systemName: "clock.fill") {
        didSet {
            layoutAccessories()
        }
    }
    
    var label = UILabel()
    
    public var buttonTitle: String = "Button" {
        didSet {
            layoutAccessories()
        }
    }
    
    var detailContainer: UIImageView!
    
    public var detail: UIImage? = K.detail.chevron {
        didSet {
            layoutAccessories()
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutAccessories()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutAccessories()
    }
    
    func layoutAccessories() {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        
        imageContainer = UIImageView(image: image).then {
            
            $0.tintColor = K.colors.gunmetal
            
            self.addSubview($0) { (make) in
                make.height.equalTo(self.snp.height).multipliedBy(0.32)
                make.width.equalTo(self.snp.height).multipliedBy(0.32)
                make.left.equalTo(self.snp.left).offset(24)
                make.centerY.equalTo(self.snp.centerY)
            }
        }
        
        label = UILabel().then {
            $0.text = buttonTitle
            $0.font = UIFont(name: FontName.AvenirNextMedium, size: 13 * widthModifier)
        }
        

        self.addSubview(label) { (make) in
            make.left.equalTo(imageContainer.snp.right).offset(24).multipliedBy(widthModifier)
            make.width.equalTo(self.snp.width).multipliedBy(0.562)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(self.snp.height).multipliedBy(0.45)
        }
        
        detailContainer = UIImageView(image: detail).then {
            
            $0.contentMode = .scaleAspectFit
            $0.tintColor = K.colors.gunmetal
            
            self.addSubview($0) { (make) in
                make.height.equalTo(self.snp.height).multipliedBy(0.25)
                make.width.equalTo(self.snp.height).multipliedBy(0.16)
                make.right.equalTo(self.snp.right).offset(-24 * widthModifier)
                make.centerY.equalTo(self.snp.centerY)
            }
        }
       
    }
    
    func accessory(image: UIImage, tint: UIColor) {
        
        for view in self.subviews {
            if view.tag == 110 || view.tag == 111 {
                view.removeFromSuperview()
            }
        }
        
        let imgview = UIImageView(image: image)
        imgview.tintColor = tint
        imgview.contentMode = .scaleAspectFit
        imgview.tag = 110
        
        self.addSubview(imgview) { (make) in
            make.right.equalTo(self.detailContainer.snp.right).offset(-24 * widthModifier)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.width.equalTo(self.snp.height).multipliedBy(0.3)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.layoutSubviews()
    }
    
    func accessory(title: String, tint: UIColor) {
        
        for view in self.subviews {
            if view.tag == 110 || view.tag == 111 {
                view.removeFromSuperview()
            }
        }
        
        let label = UILabel()
        label.text = title
        label.font = fontTypes.h3_medium
        label.textColor = tint
        label.textAlignment = .right
        label.tag = 111
        
        self.addSubview(label) { (make) in
            make.right.equalTo(self.detailContainer.snp.right).offset(-24 * widthModifier)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.width.equalTo(self.snp.width).multipliedBy(0.16)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.layoutSubviews()
    }
    
    func separateBottom(active: Bool) {
        
        if active {
            let _ = UIView().then {
                $0.backgroundColor = K.colors.gunmetal
                $0.alpha = 0.5
                $0.layer.cornerRadius = 1
                $0.tag = 200
                
                self.addSubview($0) { (make) in
                    make.height.equalTo(1)
                    make.width.equalTo(self.snp.width).multipliedBy(0.82)
                    make.bottom.equalTo(self.snp.bottom).offset(0.5)
                    make.centerX.equalTo(self.snp.centerX)
                }
            }
            self.clipsToBounds = false
        } else {
            for view in self.subviews {
                if view.tag == 200 {
                    view.removeFromSuperview()
                }
            }
        }

        self.layoutSubviews()
    }
    
    
}

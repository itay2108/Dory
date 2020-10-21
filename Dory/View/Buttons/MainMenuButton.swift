//
//  MainMenuButton.swift
//  Dory
//
//  Created by itay gervash on 07/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit
import SwiftFontName

final class MainMenuButton: UIButton {

    let fontTypes = FontTypes()
    
    //subviews
    
    lazy var imageContainer: UIImageView = {
        let imgview = UIImageView()
        imgview.tintColor = K.colors.gunmetal
        
        let img = UIImage()
        if let img = UIImage(systemName: "clock.fill") {
            imgview.image = img
        }
        
        return imgview
    }()
    
    public var image: UIImage? = UIImage(systemName: "clock.fill") {
        didSet {
            imageContainer.image = image
            layoutSubviews()
        }
    }
    
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.text = buttonTitle
        lbl.font = fontTypes.h4_medium
        return lbl
    }()
    
    public var buttonTitle: String = "Button" {
        didSet {
            label.text = buttonTitle
            layoutSubviews()
        }
    }
    
    lazy var detailContainer: UIImageView = {
        let imgview = UIImageView()
        imgview.tintColor = K.colors.gunmetal
        imgview.contentMode = .scaleAspectFit
        
        if let image = detail {
            imgview.image = detail
        }
        
        return imgview
    }()
    
    public var detail: UIImage? = K.detail.chevron {
        didSet {
            detailContainer.image = detail
        }
    }
    
    lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = K.colors.gunmetal
        separator.alpha = 0.5
        separator.layer.cornerRadius = 1
        separator.tag = 200
        
        separator.isHidden = true
        return separator
    }()
    
    func setUpView() {
        addSubviews()
        setConstraintsToSubviews()
    }
    
    func addSubviews() {
        self.addSubview(imageContainer)
        self.addSubview(label)
        self.addSubview(detailContainer)
        
        self.addSubview(separator)
    }
    
    func setConstraintsToSubviews() {
        
        imageContainer.snp.makeConstraints { (make) in
            make.height.equalTo(self.snp.height).multipliedBy(0.32)
            make.width.equalTo(self.snp.height).multipliedBy(0.32)
            make.left.equalTo(self.snp.left).offset(24)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imageContainer.snp.right).offset(24).multipliedBy(widthModifier)
            make.width.equalTo(self.snp.width).multipliedBy(0.562)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(self.snp.height).multipliedBy(0.45)
        }
        
        detailContainer.snp.makeConstraints { (make) in
            make.height.equalTo(self.snp.height).multipliedBy(0.25)
            make.width.equalTo(self.snp.height).multipliedBy(0.16)
            make.right.equalTo(self.snp.right).offset(-24 * widthModifier)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        separator.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.equalTo(self.snp.width).multipliedBy(0.82)
            make.bottom.equalTo(self.snp.bottom).offset(0.5)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
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
        
        self.addSubview(imgview)
        imgview.snp.makeConstraints { (make) in
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
        
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.right.equalTo(self.detailContainer.snp.right).offset(-24 * widthModifier)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.width.equalTo(self.snp.width).multipliedBy(0.16)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.layoutSubviews()
    }
    
    func separateBottom(active: Bool) {
        
        if active {
            separator.isHidden = false
            self.clipsToBounds = false
        } else {
            separator.isHidden = true
            self.clipsToBounds = true
        }
        self.layoutSubviews()
    }
    
    
}

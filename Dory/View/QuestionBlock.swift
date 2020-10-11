//
//  QuestionBlock.swift
//  Dory
//
//  Created by itay gervash on 10/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionBlock: UIView {
    
    let heightModifier: CGFloat = UIScreen.main.bounds.size.height / 812
    let widthModifier: CGFloat = UIScreen.main.bounds.size.width / 375
    let fontTypes = FontTypes()
    
    var realmTarget: Any?
    
    var isAnswered: Bool = false
    
    var questionTitle: String? {
        didSet {
            layoutAccessories()
        }
    }
    
    var detailTitle: String? {
        didSet {
            layoutAccessories()
        }
    }
    
    var completionDetail = UIImageView()
    
    var answerAreaContainer = UIView()
    
    private func layoutAccessories() {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        //title
        let titleLabel = UILabel()
        titleLabel.font = fontTypes.h2_medium
        titleLabel.textColor = K.colors.gunmetal
        titleLabel.text = questionTitle
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10 * heightModifier)
            make.left.equalToSuperview().offset(28 * heightModifier)
            make.height.equalTo(titleLabel.font.pointSize + 4)
            make.width.equalTo(titleLabel.intrinsicContentSize.width)
        }
        
        //checkmark
        completionDetail = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        completionDetail.tintColor = K.colors.green
        
        self.addSubview(completionDetail)
        
        completionDetail.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10 * widthModifier)
            make.height.equalTo(titleLabel.snp.height)
            make.width.equalTo(completionDetail.snp.height)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        completionDetail.isHidden = true
        
        //detail
        
        let detailLabel = UILabel()
        detailLabel.font = fontTypes.h5
        detailLabel.textColor = K.colors.gunmetal
        detailLabel.text = questionTitle
        
        self.addSubview(detailLabel)
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(4 * heightModifier)
            
            if detailTitle == nil { make.height.equalTo(0) } else {
                make.height.equalTo(titleLabel.font.pointSize + 2)
            }
            
            make.width.equalTo(titleLabel.intrinsicContentSize.width)
            
        }
        
        // answer part
        self.addSubview(answerAreaContainer)
        
        answerAreaContainer.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
    init(frame: CGRect, target: Any?) {
        super.init(frame: frame)
        
        realmTarget = target
        layoutAccessories()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

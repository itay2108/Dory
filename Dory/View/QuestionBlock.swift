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
    
    //parameters

    let fontTypes = FontTypes()
    
    var realmTarget: Any?
    
    var isAnswered: Bool = false
    var answer: Any? 
    
    //views
    
    var questionTitle: String? {
        didSet {
            titleLabel.text = questionTitle
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Question Title!!!!!"
        label.font = fontTypes.h2_medium
        label.textColor = K.colors.gunmetal
        return label
    }()
    
    var detailTitle: String? {
        didSet {
            detailLabel.text = detailTitle
        }
    }
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Detail Title"
        label.font = fontTypes.h5
        label.textColor = K.colors.gunmetal
        return label
    }()
    
    lazy var completionDetail: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.circle")
        view.tintColor = K.colors.green
        view.isHidden = true
        return view
    }()
    
    var answerAreaContainer = UIView()
    
    private func setUpView() {
        addSubviews()
        setConstraintsForSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(completionDetail)
        
        self.addSubview(detailLabel)
        
        self.addSubview(answerAreaContainer)
    }
    
    private func setConstraintsForSubviews() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10 * heightModifier)
            make.left.equalToSuperview().offset(28 * heightModifier)
            make.height.equalTo(titleLabel.font.pointSize + 4)
            make.width.equalTo(titleLabel.intrinsicContentSize.width)
        }
        
        completionDetail.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10 * widthModifier)
            make.height.equalTo(titleLabel.snp.height)
            make.width.equalTo(completionDetail.snp.height)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(4 * heightModifier)
            
            if detailTitle == nil { make.height.equalTo(0) } else {
                make.height.equalTo(titleLabel.font.pointSize + 2)
            }
            
            make.width.equalTo(detailLabel.intrinsicContentSize.width)
            
        }
        
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
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}

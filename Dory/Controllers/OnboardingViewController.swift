//
//  OnboardingViewController.swift
//  Dory
//
//  Created by itay gervash on 05/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class OnboardingViewController: UIViewController {

    let heightModifier: CGFloat = UIScreen.main.bounds.size.height / 812
    let widthModifier: CGFloat = UIScreen.main.bounds.size.width / 375
    let fontTypes = FontTypes()
    
    let realm = try! Realm()
    let cycleModel = CycleModel()
    
    //top text
    
    private lazy var topStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .leading
        sv.spacing = 8 * widthModifier
        return sv
    }()
    
    private lazy var backButton: BackButton = {
       let btn = BackButton()
        btn.tintColor = K.colors.gunmetal
        btn.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
       return btn
    }()
    
    private lazy var mainHeading: UILabel = {
        let hdg = UILabel(frame: .zero)
        hdg.font = fontTypes.h1
        hdg.numberOfLines = 1
        hdg.text = "A few questions"
        hdg.textColor = UIColor(named: "gunmetal")
        return hdg
    }()
    
    private lazy var secondaryHeading: UILabel = {
        let hdg = UILabel(frame: .zero)
        hdg.font = fontTypes.h3
        hdg.numberOfLines = 0
        hdg.text = "To start tracking your ring progress, please\nanswer these short questions"
        hdg.textColor = UIColor(named: "gunmetal")
        return hdg
    }()
    
    //question blocks
    
    //question 1
    private lazy var blockOne: QuestionBlock = {
        let block = QuestionBlock(frame: .zero, target: cycleModel.currentCycle?.state)
        block.questionTitle = "Is your ring currently inside?"
        return block
    }()
    
    private lazy var blockOneAnswerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.spacing = 22 * widthModifier
        return sv
    }()
    
    private lazy var choiceBtnYes: OnboardingChoiceButton = {
        let btn = OnboardingChoiceButton(frame: .zero)
        btn.choice = true
        btn.tintColor = K.colors.gunmetal
        btn.setTitle("Yes", for: .normal)
        btn.addTarget(self, action: #selector(firstQuestionAnswered(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var choiceBtnNo: OnboardingChoiceButton = {
        let btn = OnboardingChoiceButton(frame: .zero)
        btn.choice = false
        btn.tintColor = K.colors.gunmetal
        btn.setTitle("No", for: .normal)
        btn.addTarget(self, action: #selector(firstQuestionAnswered(sender:)), for: .touchUpInside)
        return btn
    }()
    
    
    //bottom part
    
    private lazy var continueButton: OnboardingButton = {
        let btn = OnboardingButton(frame: .zero)
        btn.tintColor = K.colors.gunmetal
        btn.setTitle("Continue", for: .normal)
        btn.addTarget(self, action: #selector(continueBtnPressed), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        addStaticSubviews()
        addConstraintsForAllSubviews()
        
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true

    }
    
    private func addStaticSubviews() {
        
        self.view.addSubview(topStackView)
        
        topStackView.addArrangedSubview(backButton)
        topStackView.addArrangedSubview(mainHeading)
        
        self.view.addSubview(secondaryHeading)
        
        self.view.addSubview(blockOne)
        blockOne.addSubview(choiceBtnYes)
        blockOne.addSubview(choiceBtnNo)
        
        blockOne.answerAreaContainer.addSubview(blockOneAnswerStackView)
        blockOneAnswerStackView.addArrangedSubview(choiceBtnYes)
        blockOneAnswerStackView.addArrangedSubview(choiceBtnNo)
        
        self.view.addSubview(continueButton)
    }
    
    
    private func addConstraintsForAllSubviews() {
        
        //titles
        
        topStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(72 * heightModifier)
            make.left.equalToSuperview().offset(17 * widthModifier)
            make.height.equalTo(mainHeading.font.pointSize + 4)
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { (make) in
            make.width.equalTo(topStackView.snp.height).multipliedBy(0.6)
        }

        secondaryHeading.snp.makeConstraints { (make) in
            make.top.equalTo(mainHeading.snp.bottom).offset(6 * heightModifier)
            make.left.equalToSuperview().offset(24)
        }
        
        //question 1
        
        blockOne.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(90 * heightModifier)
            make.top.equalTo(secondaryHeading.snp.bottom).offset(40 * heightModifier)
            make.right.equalToSuperview()
        }
        
        blockOneAnswerStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(28 * widthModifier)
            make.right.equalToSuperview().offset(-28 * widthModifier)
            make.bottom.equalToSuperview()
        }
        
        choiceBtnYes.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        
        choiceBtnNo.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        
        
        continueButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-64 * heightModifier)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(30 * widthModifier)
            make.height.equalTo(56 * heightModifier)
            
            self.continueButton.layer.cornerRadius = 14
        }
        
    }
    
    
    @objc func continueBtnPressed() {
        //push next vc here
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func firstQuestionAnswered(sender: OnboardingButton) {
        
        //select sender and deselect other button
        
        let nonSender = sender == choiceBtnYes ? choiceBtnNo : choiceBtnYes
        
        sender.isSelected = true
        nonSender.isSelected = false
        
        
        print("sender: \(String(describing: sender.titleLabel?.text)), non sender: \(String(describing: nonSender.titleLabel?.text))")
        //show chekcmark
        
        blockOne.isAnswered = true
        blockOne.completionDetail.isHidden = false
        
        //update constraints
        
        let selectedWidth = (blockOneAnswerStackView.frame.size.width * 0.7) - 11
        let nonSelectedWidth = blockOneAnswerStackView.frame.size.width - 22 - selectedWidth
        
        blockOneAnswerStackView.distribution = .fill
        
        UIView.animate(withDuration: 0.3) {
            sender.snp.remakeConstraints { (make) in
                make.height.equalToSuperview().multipliedBy(0.9)
                make.width.equalTo(selectedWidth)
            }
            
            nonSender.snp.remakeConstraints { (make) in
                make.height.equalToSuperview().multipliedBy(0.9)
                make.width.equalTo(nonSelectedWidth)
            }
        }
        

     }

}

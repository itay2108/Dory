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
    
    //question 2
    private lazy var blockTwo: QuestionBlock = {
        let block = QuestionBlock(frame: .zero, target: cycleModel.currentCycle?.state)
        block.questionTitle = "When did you insert it?"
        return block
    }()
    
    private lazy var datePicker: DatePickerLabel = {
        let picker = DatePickerLabel()
        picker.trigger.isEnabled = true
        picker.trigger.addTarget(self, action: #selector(datePickerTapped), for: .touchUpInside)
        return picker
    }()
    
    //calendar card
    private lazy var calendarContainer = CardView()

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
        
        print(heightModifier, widthModifier)

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        addSubviews()
        setConstraintsForSubviews()
        
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true

    }
    
    //MARK: - view layout
    
    private func addSubviews() {
        
        //titles
        
        self.view.addSubview(topStackView)
        
        topStackView.addArrangedSubview(backButton)
        topStackView.addArrangedSubview(mainHeading)
        
        //question 1
        self.view.addSubview(secondaryHeading)
        
        self.view.addSubview(blockOne)
        blockOne.addSubview(choiceBtnYes)
        blockOne.addSubview(choiceBtnNo)
        
        blockOne.answerAreaContainer.addSubview(blockOneAnswerStackView)
        blockOneAnswerStackView.addArrangedSubview(choiceBtnYes)
        blockOneAnswerStackView.addArrangedSubview(choiceBtnNo)
        
        //question 2
        self.view.addSubview(blockTwo)
        blockTwo.answerAreaContainer.addSubview(datePicker)
        
        self.view.addSubview(continueButton)
        
    }
    
    
    private func setConstraintsForSubviews() {
        
        //titles
        
        topStackView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaTop).offset(-12 * heightModifier)
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
            make.top.equalTo(secondaryHeading.snp.bottom).offset(32 * heightModifier)
            make.right.equalToSuperview()
        }
        
        blockOne.titleLabel.snp.updateConstraints { (make) in
            make.width.equalTo(blockOne.titleLabel.intrinsicContentSize.width)
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
        
        //question 2
        blockTwo.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(90 * heightModifier)
            make.top.equalTo(blockOne.snp.bottom).offset(32 * heightModifier)
            make.right.equalToSuperview()
        }
        
        blockTwo.titleLabel.snp.updateConstraints { (make) in
            make.width.equalTo(blockTwo.titleLabel.intrinsicContentSize.width)
        }
        
        
        datePicker.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(28 * widthModifier)
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5).offset(22)
        }

            
        //bottom
        continueButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(safeAreaBottom).offset(-32 * heightModifier)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(30 * widthModifier)
            make.height.equalTo(56 * heightModifier)
            
            self.continueButton.layer.cornerRadius = 14 * heightModifier
        }
        
    }
    
    //MARK: - button targets
    

    
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
    
    @objc func continueBtnPressed() {
        //push next vc here
    }
    
    @objc func datePickerTapped() {
        //open calendar
        print("Date picker tapped")
        
        self.view.addSubview(calendarContainer)
        
        calendarContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        calendarContainer.animateViewIn()

    }
    
}

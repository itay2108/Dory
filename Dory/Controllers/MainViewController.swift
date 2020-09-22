//
//  ViewController.swift
//  Dory
//
//  Created by itay gervash on 23/08/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import RealmSwift
import Then
import SnapKit
import SwiftFontName

class MainViewController: UIViewController {
    
    //MARK: - VC Properties
    
    private let realm = try! Realm()
    private let def = UserDefaults.standard
    
    private var calendar = Calendar.current
    private var dateFormatter = DateFormatter()
    private var now: Date! = Date()
    
    private var cycleModel = CycleModel()
    
    private var fontTypes = FontTypes()
    
    let heightModifier: CGFloat = UIScreen.main.bounds.size.height / 812
    let widthModifier: CGFloat = UIScreen.main.bounds.size.width / 375
    
    //UI elements
    
    private lazy var mainHeading = UILabel()
    private lazy var secondaryHeading = UILabel()
    
    private var daysContainer = UIView()
    private lazy var circleProgressView = CircleProgressView()
    private lazy var daysToActionLabel = UILabel()
    private lazy var daysHoursLabel = UILabel()
    
    private lazy var middleStackView = UIStackView()
    
    private lazy var leftDateStackView = UIStackView()
    private lazy var removeOnLabel = UILabel()
    private lazy var removeDateLabel = UILabel()
    
    private lazy var rightDateStackView = UIStackView()
    private lazy var insertOnLabel = UILabel()
    private lazy var insertDateLabel = UILabel()
    
    private var bottomStackView: UIStackView?
    private var reminderTimeButton: MainMenuButton?
    private var postponeRingRemovalButton: MainMenuButton?
    private var prescriptionNotificationButton: MainMenuButton?
    private var changeCycleButton: MainMenuButton?
    
    private lazy var actionBtn: UIButton! = UIButton()
    
    //MARK: - Default Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n\n-----------------------\nRealm is stored in:\n", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask), "\n-----------------------\n")
        
        if UIApplication.isFirstLaunch() { print("first launch") }
        
        print(heightModifier, widthModifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUIComponents), name: updateParametersNotificationName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initUIViews()
    }
    
    override func viewDidLayoutSubviews() {
        setUpTestDayButton()
        updateUIComponents()
        
    }
    
    
    //MARK: - UI Initialization
    
    func initUIViews() {
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        //Headings
        
        mainHeading = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40)).then {
            $0.font = fontTypes.h1
            $0.numberOfLines = 1
            $0.text = "Good Night Dory"
            $0.textColor = UIColor(named: "gunmetal")
        }
        view.addSubview(mainHeading) { (make) in
            make.top.equalTo(view).offset(60 * heightModifier)
            make.left.equalToSuperview().offset(24)
        }
        
        secondaryHeading = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20)).then {
            $0.font = fontTypes.h3
            $0.numberOfLines = 1
            $0.text = "Remember to \(cycleModel.nextAction?.rawValue ?? "remove(error)") your ring in"
            $0.textColor = UIColor(named: "gunmetal")
        }
        view.addSubview(secondaryHeading) { (make) in
            make.top.equalTo(mainHeading.snp.bottom).offset(6 * heightModifier)
            make.left.equalToSuperview().offset(24)
        }
        
        //Days Container
        
        daysContainer = UIView(frame: CGRect(x: 0, y: 0, width: 204 * heightModifier, height: 204 * heightModifier)).then {
            $0.circlize()
            $0.shadow(color: .black, radius: 9, opacity: 0.07, xOffset: 0, yOffset: 7.4)
            $0.backgroundColor = .white
        }
        view.addSubview(daysContainer) { (make) in
            make.height.equalTo(204 * heightModifier)
            make.width.equalTo(daysContainer.snp.height)
            make.top.equalTo(secondaryHeading.snp.bottom).offset(36 * heightModifier)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        circleProgressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: 192, height: 192)).then {
            $0.roundedCap = true
            $0.trackFillColor = K.colors.sizzlingRed!
            $0.trackWidth = 11 * heightModifier
            $0.centerFillColor = .clear
            $0.backgroundColor = .clear
            $0.trackBackgroundColor = .clear
            $0.clockwise = true
            $0.progress = 0.75
        }
        daysContainer.addSubview(circleProgressView) { (make) in
            make.height.equalTo(daysContainer.snp.height).multipliedBy(0.85)
            make.width.equalTo(daysContainer.snp.width).multipliedBy(0.85)
            make.center.equalToSuperview()
        }
        
        daysToActionLabel = label(font: fontTypes.xl, numberOfLines: 1, text: "99")
        
        daysContainer.addSubview(daysToActionLabel) { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10 * heightModifier)
            make.height.equalTo(daysToActionLabel.font.pointSize + 2)
        }
        
        daysHoursLabel = label(font: fontTypes.h2, numberOfLines: 1, text: "days")
        
        daysContainer.addSubview(daysHoursLabel) { (make) in
            make.top.equalTo(daysToActionLabel.snp.bottom).offset(4 * heightModifier)
            make.centerX.equalToSuperview()
        }
        
        //Middle Dates
        
        middleStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .equalCentering
            $0.alignment = .center
        }
        
        view.addSubview(middleStackView) { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(daysContainer.snp.bottom).offset(32 * heightModifier)
            make.width.equalTo(view.snp.width).multipliedBy(0.65 * widthModifier)
            make.height.equalTo(60 * heightModifier)
        }
        
        //left part
        leftDateStackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = 6 / heightModifier
            $0.alignment = .center
            
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(75 * widthModifier)
                make.height.equalTo(50 * heightModifier)
            }
        }

        
        removeOnLabel = label(font: fontTypes.h3, numberOfLines: 1, text: "Remove on")
        leftDateStackView.addArrangedSubview(removeOnLabel)
        
        removeDateLabel = label(font: fontTypes.h2_medium, numberOfLines: 1, text: "14/11/23")
        leftDateStackView.addArrangedSubview(removeDateLabel)
        
        middleStackView.addArrangedSubview(leftDateStackView)
        
        //separator
        
        let separator = UIView().then {
            $0.backgroundColor = UIColor(named: "gunmetal")
            
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(1)
            }
        }
        
        middleStackView.addArrangedSubview(separator)
        
        separator.snp.makeConstraints { (make) in
            make.height.equalTo(middleStackView.snp.height).multipliedBy(0.75)
        }
        
        //right part
        rightDateStackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = 6 / heightModifier
            $0.alignment = .center
            
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(75 * widthModifier)
                make.height.equalTo(50 * heightModifier)
            }
        }
        
        
        insertOnLabel = label(font: fontTypes.h3, numberOfLines: 1, text: "Insert on")
        rightDateStackView.addArrangedSubview(insertOnLabel)
        
        insertDateLabel = label(font: fontTypes.h2_medium, numberOfLines: 1, text: "21/11/23")
        rightDateStackView.addArrangedSubview(insertDateLabel)
        
        middleStackView.addArrangedSubview(rightDateStackView)
        
        
        
        //Bottom part
        let bottomBG = UIView().then {
            $0.backgroundColor = UIColor(named: "alice blue")
        }
        
        view.addSubview(bottomBG) { (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        
        //buttons
        
        bottomStackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .equalCentering
            $0.alignment = .fill
        }
        
        view.addSubview(bottomStackView!) { (make) in
            make.width.equalTo(view.snp.width)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(bottomBG.snp.top)
            make.bottom.equalTo(view.snp.bottom).offset(-(view.safeAreaInsets.bottom + (6 * heightModifier)))
        }
        
        reminderTimeButton = MainMenuButton().then {
            $0.addTarget(self, action: #selector(setReminderButtonTapped), for: .touchUpInside)
            $0.buttonTitle = "Set reminder time"

            $0.accessory(title: "13:00", tint: .lightGray)
            $0.separateBottom(active: true)
        }

        postponeRingRemovalButton = MainMenuButton().then {
            $0.addTarget(self, action: #selector(postponeNextRemovalButtonTapped), for: .touchUpInside)
            $0.image = K.buttonImage.clockwiseArrow
            $0.buttonTitle = "Postpone next ring removal"
            $0.separateBottom(active: true)
        }

        prescriptionNotificationButton = MainMenuButton().then {
            $0.addTarget(self, action: #selector(prescriptionNotificationButtonTapped), for: .touchUpInside)
            $0.image = K.buttonImage.heart
            $0.buttonTitle = "Prescription notification"

            $0.accessory(image: K.accessory.star, tint: K.colors.yellow!)
            $0.separateBottom(active: true)
        }

        changeCycleButton = MainMenuButton().then {
            $0.addTarget(self, action: #selector(changeCycleButtonTapped), for: .touchUpInside)
            $0.image = K.buttonImage.swap
            $0.buttonTitle = "Change cycle"
        }
        
        
        let stack = [reminderTimeButton!, postponeRingRemovalButton!, prescriptionNotificationButton!, changeCycleButton!]
        
        for i in stack {
            bottomStackView?.addArrangedSubview(i)
            
            i.snp.makeConstraints { (make) in
                make.height.equalTo(bottomStackView!.snp.height).multipliedBy(0.24)
            }

        }
        
    }
    
    private func initActionBtn() {
        
        let actionBtn = UIButton().then {
            $0.backgroundColor = K.colors.sizzlingRed
            
            $0.titleLabel?.font = fontTypes.h3_medium
            $0.titleLabel?.textColor = K.colors.ghostWhite
            $0.tintColor = .white
            $0.setTitle("\(cycleModel.nextAction?.rawValue.capitalized ?? "remove(error)") ring", for: .normal)
            $0.layer.cornerRadius = 32
            $0.addTarget(self, action: #selector(actionBtnPressed(_:)), for: .touchUpInside)
        }
        
        view.addSubview(actionBtn) { (make) in
            make.height.equalTo(middleStackView.snp.height)
            make.width.equalTo(middleStackView.snp.width)
            make.center.equalTo(middleStackView.snp.center)
        }
        
    }
    
    
    //MARK: - Button Actions
    
    @objc func setReminderButtonTapped() {
        print("remider btn tapped")
    }
    
    @objc func postponeNextRemovalButtonTapped() {
        print("postpone removal button tapped")
    }
    
    @objc func prescriptionNotificationButtonTapped() {
        print("prescription button tapped")
    }
    
    @objc func changeCycleButtonTapped() {
        print("change cycle button tapped")
    }
    
    @objc func actionBtnPressed(_ sender: UIButton!) {
        print(cycleModel.currentCycle?.state as Any)
        if cycleModel.currentCycle?.state == 0 {
            cycleModel.changeRingState(to: -1)
            updateUIComponents()
        } else if cycleModel.currentCycle?.state == -1 {
            cycleModel.startNewCycle()
            updateUIComponents()
        }
        
        sender.removeFromSuperview()
    }

    
    //MARK: - UI Methods
    
    @objc private func updateUIComponents() {
        
        cycleModel.setParameters()
        
        guard cycleModel.currentCycle?.expectedEndDate != nil && cycleModel.currentCycle?.expectedRemovalDate != nil else { return }
        
        daysToActionLabel.text = "\(cycleModel.daysToAction ?? -1)"
        circleProgressView.progress = Double(cycleModel.daysToAction!) / Double(cycleModel.cyclePartLength!)
        
        //set remove date label by state
        
        if cycleModel.currentCycle?.state == -1 {
            removeDateLabel.text = cycleModel.currentCycle?.removalDate?.asString(format: "dd/MM/yy")
        } else if cycleModel.currentCycle?.state == 0 {
            removeDateLabel.text = cycleModel.currentCycle?.expectedRemovalDate?.asString(format: "dd/MM/yy")
        } else if cycleModel.currentCycle?.state == 1 {
            removeDateLabel.text = cycleModel.currentCycle?.expectedRemovalDate?.asString(format: "dd/MM/yy")
        }
        
        //set insert date label by checking if expected end date has passed

        if Date() > (cycleModel.currentCycle?.expectedEndDate)! {
            insertDateLabel.text = Date().asString(format: "dd/MM/yy")
        } else {
            insertDateLabel.text = cycleModel.currentCycle?.expectedEndDate?.asString(format: "dd/MM/yy")
        }
        
        if cycleModel.currentCycle?.state == 0 {
            initActionBtn()
            circleProgressView.progress = 1
        }
        
        if circleProgressView.progress == 1 { circleProgressView.roundedCap = false }
        else if circleProgressView.progress > 1 { circleProgressView.progress = 1 } else {
            circleProgressView.roundedCap = true
        }
        
    }
    
    func label(font: UIFont, numberOfLines: Int?, text: String?) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20)).then {
            $0.font = font
            $0.numberOfLines = numberOfLines ?? 1
            $0.textColor = K.colors.gunmetal
            $0.text = text ?? "Label"
        }
        
        return label
    }
    
    
    
    //MARK: - Internal methods
    
    func divide(stack: [UIView]) -> [UIView] {
        var dividedStack: [UIView] = []
        
        let divider = UIView().then {
            $0.backgroundColor = K.colors.gunmetal
            
            $0.snp.makeConstraints { (make) in
                make.height.equalTo(2)
                make.width.equalTo(UIScreen.main.bounds.size.width).multipliedBy(0.75)
            }
        }
        
        for i in stack {
            dividedStack.append(i)
            let d = divider
            dividedStack.append(d)
        }
        
        dividedStack.remove(at: (dividedStack.count - 1))

        
        return dividedStack
    }

    
    //MARK: - Testing methods (Comment out before production!)
    
    func setUpTestDayButton() {
        let dayTestButton = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 30))
        dayTestButton.backgroundColor = .clear
        dayTestButton.layer.cornerRadius = 12
        dayTestButton.setTitle("day++", for: .normal)
        dayTestButton.setTitleColor(.link, for: .normal)
        dayTestButton.titleLabel?.font = fontTypes.h3
        dayTestButton.addTarget(self, action: #selector(skipDayBtnPressed(_:)), for: .touchUpInside)
        

        view.addSubview(dayTestButton) { (make) in
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(view.snp.top).offset(16 + self.view.safeAreaInsets.top)
            make.width.equalTo(48)
            make.height.equalTo(30)
        }

    }
    
    @objc func skipDayBtnPressed(_ sender: UIButton!) {
        cycleModel.now = dayPlusPlus(modify: cycleModel.now)!
        
    }
    
    
    private func dayPlusPlus(modify date: Date) -> Date? {
        return calendar.date(byAdding: .day, value: 1, to: date)
    }
    
    
}



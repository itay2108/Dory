//
//  ViewController.swift
//  Dory
//
//  Created by itay gervash on 23/08/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import RealmSwift
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

    
    //UI elements
    
    private lazy var mainHeading: UILabel = {
        let hdg = UILabel(frame: .zero)
        hdg.font = fontTypes.h1
        hdg.numberOfLines = 1
        hdg.text = "Good Night Dory"
        hdg.textColor = UIColor(named: "gunmetal")
        return hdg
    }()
    
    private lazy var secondaryHeading: UILabel = {
        let hdg = UILabel(frame: .zero)
        hdg.font = fontTypes.h3
        hdg.numberOfLines = 1
        hdg.text = "Remember to \(cycleModel.nextAction?.rawValue ?? "remove(error)") your ring in"
        hdg.textColor = UIColor(named: "gunmetal")
        return hdg
    }()
    
    private lazy var daysContainer: UIView = {
        let container = UIView()
        container.shadow(color: .black, radius: 9, opacity: 0.07, xOffset: 0, yOffset: 7.4)
        container.backgroundColor = .white
        return container
    }()
    
    private lazy var circleProgressView: CircleProgressView = {
        let circle = CircleProgressView()
        circle.roundedCap = true
        circle.trackFillColor = K.colors.sizzlingRed!
        circle.trackWidth = 11 * heightModifier
        circle.centerFillColor = .clear
        circle.backgroundColor = .clear
        circle.trackBackgroundColor = .clear
        circle.clockwise = true
        circle.progress = 0.75
        return circle
    }()
    
    private lazy var daysToActionLabel: UILabel = {
        return label(font: fontTypes.xl, numberOfLines: 1, text: "99")
    }()
    
    private lazy var daysHoursLabel: UILabel = {
        return label(font: fontTypes.h2, numberOfLines: 1, text: "days")
    }()
    
    private lazy var middleStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalCentering
        stackview.alignment = .center
        return stackview
    }()
    
    private lazy var leftDateStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.spacing = 6 / heightModifier
        stackview.alignment = .center
        return stackview
    }()
    
    private lazy var removeOnLabel: UILabel = {
        return label(font: fontTypes.h3, numberOfLines: 1, text: "Remove on")
    }()
    
    private lazy var removeDateLabel: UILabel = {
        return label(font: fontTypes.h2_medium, numberOfLines: 1, text: "14/11/23")
    }()
    
    private lazy var separator: UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor(named: "gunmetal")
        return sep
    }()
    
    private lazy var rightDateStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.spacing = 6 / heightModifier
        stackview.alignment = .center
        return stackview
    }()
    
    private lazy var insertOnLabel: UILabel =  {
        return label(font: fontTypes.h3, numberOfLines: 1, text: "Insert on")
    }()
    
    private lazy var insertDateLabel: UILabel = {
        return label(font: fontTypes.h2_medium, numberOfLines: 1, text: "21/11/23")
    }()
    
    private lazy var bottomBG: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "alice blue")
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalCentering
        stackview.alignment = .fill
        return stackview
    }()
    
    private lazy var reminderTimeButton: MainMenuButton = {
        let button = MainMenuButton()
        button.addTarget(self, action: #selector(setReminderButtonTapped), for: .touchUpInside)
        button.buttonTitle = "Set reminder time"
        button.accessory(title: "13:00", tint: .lightGray)
        button.separateBottom(active: true)
        return button
    }()
    
    private lazy var postponeRingRemovalButton: MainMenuButton = {
        let button = MainMenuButton()
        button.addTarget(self, action: #selector(postponeNextRemovalButtonTapped), for: .touchUpInside)
        button.image = K.buttonImage.clockwiseArrow
        button.buttonTitle = "Postpone next ring removal"
        button.separateBottom(active: true)
        return button
    }()
    
    private lazy var prescriptionNotificationButton: MainMenuButton = {
        let button = MainMenuButton()
        button.addTarget(self, action: #selector(prescriptionNotificationButtonTapped), for: .touchUpInside)
        button.image = K.buttonImage.heart
        button.buttonTitle = "Prescription notification"
        button.accessory(image: K.accessory.star, tint: K.colors.yellow!)
        button.separateBottom(active: true)
        return button
    }()
    
    private lazy var changeCycleButton: MainMenuButton = {
        let button = MainMenuButton()
        button.addTarget(self, action: #selector(changeCycleButtonTapped), for: .touchUpInside)
        button.image = K.buttonImage.swap
        button.buttonTitle = "Change cycle"
        return button
    }()
    
    private lazy var actionBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = K.colors.sizzlingRed
        button.titleLabel?.font = fontTypes.h3_medium
        button.titleLabel?.textColor = K.colors.ghostWhite
        button.tintColor = .white
        button.setTitle("\(cycleModel.nextAction?.rawValue.capitalized ?? "remove(error)") ring", for: .normal)
        button.layer.cornerRadius = 32
        button.addTarget(self, action: #selector(actionBtnPressed(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var dayTestBtn: UIButton = {
        let dayTestButton = UIButton()
        dayTestButton.backgroundColor = .clear
        dayTestButton.layer.cornerRadius = 12
        dayTestButton.setTitle("day++", for: .normal)
        dayTestButton.setTitleColor(.link, for: .normal)
        dayTestButton.titleLabel?.font = fontTypes.h3
        dayTestButton.addTarget(self, action: #selector(skipDayBtnPressed(_:)), for: .touchUpInside)
        return dayTestButton
    }()
    
    //MARK: - Default Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n\n-----------------------\nRealm is stored in:\n", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask), "\n-----------------------\n")
        
        if UIApplication.isFirstLaunch() { print("first launch") }
        
        print(heightModifier, widthModifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUIComponents), name: updateParametersNotificationName, object: nil)
        
        setupUI()

    }
    
    override func viewDidLayoutSubviews() {
        daysContainer.circlize()
        bottomStackView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-(view.safeAreaInsets.bottom + (6 * heightModifier)))
        }
        updateUIComponents()
        
    }
    
    private func setupUI() {
        addSubviews()
        addConstraintsForAllSubviews()
    }
    
    
    //MARK: - UI Initialization
    
    func addSubviews() {
        
        view.addSubview(mainHeading)
        view.addSubview(secondaryHeading)
        
        view.addSubview(daysContainer)
        daysContainer.addSubview(circleProgressView)
        daysContainer.addSubview(daysToActionLabel)
        daysContainer.addSubview(daysHoursLabel)
        
        view.addSubview(middleStackView)
        middleStackView.addArrangedSubview(leftDateStackView)
        middleStackView.addArrangedSubview(separator)
        middleStackView.addArrangedSubview(rightDateStackView)
        
        leftDateStackView.addArrangedSubview(removeOnLabel)
        leftDateStackView.addArrangedSubview(removeDateLabel)
        
        rightDateStackView.addArrangedSubview(insertOnLabel)
        rightDateStackView.addArrangedSubview(insertDateLabel)
        
        view.addSubview(bottomBG)
        view.addSubview(bottomStackView)

        let stack = [reminderTimeButton, postponeRingRemovalButton, prescriptionNotificationButton, changeCycleButton]

        for i in stack {
            bottomStackView.addArrangedSubview(i)
        }

        view.addSubview(actionBtn)
        
        view.addSubview(dayTestBtn)
    }
    
    private func addConstraintsForAllSubviews() {
        
        //Headings
        
        mainHeading.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(60 * heightModifier)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(mainHeading.font.pointSize + 4)
        }

        secondaryHeading.snp.makeConstraints { (make) in
            make.top.equalTo(mainHeading.snp.bottom).offset(6 * heightModifier)
            make.left.equalToSuperview().offset(24)
        }

        //Days container

        daysContainer.snp.makeConstraints { (make) in
            make.height.equalTo(204 * heightModifier).priority(.high)
            make.width.equalTo(daysContainer.snp.height)
            make.top.equalTo(secondaryHeading.snp.bottom).offset(36 * heightModifier)
            make.centerX.equalTo(view.snp.centerX)
        }

        circleProgressView.snp.makeConstraints { (make) in
            make.height.equalTo(daysContainer.snp.height).multipliedBy(0.85)
            make.width.equalTo(daysContainer.snp.width).multipliedBy(0.85)
            make.center.equalToSuperview()
        }

        daysToActionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10 * heightModifier)
            make.height.equalTo(daysToActionLabel.font.pointSize + 2)
        }

        daysHoursLabel.snp.makeConstraints { (make) in
            make.top.equalTo(daysToActionLabel.snp.bottom).offset(4 * heightModifier)
            make.centerX.equalToSuperview()
        }

        //Middle dates

        middleStackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(daysContainer.snp.bottom).offset(32 * heightModifier)
            make.width.equalTo(view.snp.width).multipliedBy(0.65 * widthModifier)
            make.height.equalTo(60 * heightModifier)
        }

        //left part

        leftDateStackView.snp.makeConstraints { (make) in
            make.width.equalTo(75 * widthModifier)
            make.height.equalTo(50 * heightModifier)
        }

        //separator

        separator.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(middleStackView.snp.height).multipliedBy(0.75)

        }

        //right part

        rightDateStackView.snp.makeConstraints { (make) in
            make.width.equalTo(75 * widthModifier)
            make.height.equalTo(50 * heightModifier)
        }

        //bottom part

        bottomBG.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }

        bottomStackView.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(bottomBG.snp.top)
            make.bottom.equalTo(view.snp.bottom).offset(-(view.safeAreaInsets.bottom + (6 * heightModifier)))
        }

        //add buttons constraints in bottom stack view

        for i in bottomStackView.arrangedSubviews {
            i.snp.makeConstraints { (make) in
                make.height.equalTo(bottomStackView.snp.height).multipliedBy(0.24)
            }
        }

        //action button

        actionBtn.snp.makeConstraints { (make) in
            make.height.equalTo(middleStackView.snp.height)
            make.width.equalTo(middleStackView.snp.width)
            make.center.equalTo(middleStackView.snp.center)
        }

        dayTestBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalTo(mainHeading.snp.centerY)
            make.width.equalTo(48)
            make.height.equalTo(30)
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
        
        if cycleModel.currentCycle?.state == 0 {
            cycleModel.changeRingState(to: -1)
            updateUIComponents()
        } else if cycleModel.currentCycle?.state == -1 {
            cycleModel.startNewCycle()
            updateUIComponents()
        }
        
        actionBtn.isHidden = true
    }

    
    //MARK: - UI Methods
    
    @objc private func updateUIComponents() {
        
        cycleModel.setParameters()
        
        guard cycleModel.currentCycle?.expectedEndDate != nil && cycleModel.currentCycle?.expectedRemovalDate != nil else { return }
        
        daysToActionLabel.text = "\(cycleModel.daysToAction ?? -1)"
        circleProgressView.progress = Double(cycleModel.daysToAction!) / Double(cycleModel.cyclePartLength!)
        
        //set remove date label by state
        
        if cycleModel.currentCycle?.state == -1 {
            removeOnLabel.text = K.labels.removedOn
            removeDateLabel.text = cycleModel.currentCycle?.removalDate?.asString(format: "dd/MM/yy")
        } else if cycleModel.currentCycle?.state == 0 {
            removeDateLabel.text = cycleModel.currentCycle?.expectedRemovalDate?.asString(format: "dd/MM/yy")
        } else if cycleModel.currentCycle?.state == 1 {
            removeOnLabel.text = K.labels.removeOn
            removeDateLabel.text = cycleModel.currentCycle?.expectedRemovalDate?.asString(format: "dd/MM/yy")
        }
        
        //set insert date label by checking if expected end date has passed

        if cycleModel.now > (cycleModel.currentCycle?.expectedEndDate)! {
            insertDateLabel.text = cycleModel.now.asString(format: "dd/MM/yy")
        } else {
            insertDateLabel.text = cycleModel.currentCycle?.expectedEndDate?.asString(format: "dd/MM/yy")
        }
        
        //if awaiting action (removal or insertion), show action button
        
        if (cycleModel.currentCycle?.state == 0) || (cycleModel.currentCycle?.state == -1 && cycleModel.daysToAction! <= 0) {
            actionBtn.isHidden = false
            actionBtn.setTitle("\(cycleModel.nextAction?.rawValue.capitalized ?? "remove(error)") ring", for: .normal)
            circleProgressView.progress = 1
        }
        
        if circleProgressView.progress == 1 { circleProgressView.roundedCap = false }
        else if circleProgressView.progress > 1 { circleProgressView.progress = 1 } else {
            circleProgressView.roundedCap = true
        }
        
    }
    
    func label(font: UIFont, numberOfLines: Int?, text: String?) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        label.font = font
        label.numberOfLines = numberOfLines ?? 1
        label.textColor = K.colors.gunmetal
        label.text = text ?? "Label"
        
        return label
    }
    
    
    
    //MARK: - Internal methods
    
    func divide(stack: [UIView]) -> [UIView] {
        var dividedStack: [UIView] = []
        
        let divider = UIView()
        divider.backgroundColor = K.colors.gunmetal
            
        divider.snp.makeConstraints { (make) in
                make.height.equalTo(2)
                make.width.equalTo(UIScreen.main.bounds.size.width).multipliedBy(0.75)
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

    
    @objc func skipDayBtnPressed(_ sender: UIButton!) {
        cycleModel.now = dayPlusPlus(modify: cycleModel.now)!
    }
    
    
    private func dayPlusPlus(modify date: Date) -> Date? {
        return calendar.date(byAdding: .day, value: 1, to: date)
    }
    
    
}



//
//  WelcomeViewController.swift
//  Dory
//
//  Created by itay gervash on 01/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    let heightModifier: CGFloat = UIScreen.main.bounds.size.height / 812
    let widthModifier: CGFloat = UIScreen.main.bounds.size.width / 375
    let fontTypes = FontTypes()
    
    
    
    private lazy var mainHeading: UILabel = {
        let hdg = UILabel(frame: .zero)
        hdg.font = fontTypes.h1
        hdg.numberOfLines = 1
        hdg.text = "Hi there!"
        hdg.textColor = UIColor(named: "gunmetal")
        return hdg
    }()
    
    private lazy var secondaryHeading: UILabel = {
        let hdg = UILabel(frame: .zero)
        hdg.font = fontTypes.h3
        hdg.numberOfLines = 0
        hdg.text = "Dory remembers when to remove and insert\nyour ring - so you don't have to"
        hdg.textColor = UIColor(named: "gunmetal")
        return hdg
    }()
    
    private lazy var vcArtwork: UIImageView = {
        let imgview = UIImageView(frame: .zero)
        imgview.image = UIImage(named: "onboarding-1")
        imgview.contentMode = .scaleAspectFit
        return imgview
    }()

    private lazy var beginButton: OnboardingButton = {
        let btn = OnboardingButton(frame: .zero)
        btn.tintColor = K.colors.gunmetal
        btn.setTitle("Let's Begin", for: .normal)
        btn.setTitleColor(K.colors.gunmetal, for: .normal)
        btn.addTarget(self, action: #selector(beginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        addConstraintsForAllSubviews()
    }
    
    private func addSubviews() {
        
        self.view.addSubview(mainHeading)
        self.view.addSubview(secondaryHeading)
        
        self.view.addSubview(vcArtwork)
        
        self.view.addSubview(beginButton)
    }
    
    
    private func addConstraintsForAllSubviews() {
        
        mainHeading.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(72 * heightModifier)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(mainHeading.font.pointSize + 4)
        }

        secondaryHeading.snp.makeConstraints { (make) in
            make.top.equalTo(mainHeading.snp.bottom).offset(6 * heightModifier)
            make.left.equalToSuperview().offset(24)
        }
        
        vcArtwork.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.45 * heightModifier)
            make.width.equalToSuperview().multipliedBy(1.03 * widthModifier)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-40 * widthModifier)
        }
        
        beginButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-64 * heightModifier)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(30 * widthModifier)
            make.height.equalTo(56 * heightModifier)
            
            self.beginButton.layer.cornerRadius = 14
        }
    }
    
    
    @objc func beginBtnPressed() {
        //push vc here
        
        let destination = OnboardingViewController()
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    

}

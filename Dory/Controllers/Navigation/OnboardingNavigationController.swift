//
//  OnboardingNavigationController.swift
//  Dory
//
//  Created by itay gervash on 08/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit

class OnboardingNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        self.modalPresentationStyle = .fullScreen
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
    }


    
}

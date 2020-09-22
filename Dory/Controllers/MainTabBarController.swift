//
//  MainTabBarController.swift
//  Dory
//
//  Created by itay gervash on 19/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainViewController = MainViewController()
                
        mainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        let calendarViewController = CalendarViewController()

        calendarViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        let tabBarList = [mainViewController, calendarViewController]

        viewControllers = tabBarList
    }
    


}

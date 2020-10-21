//
//  CalendarCardViewController.swift
//  Dory
//
//  Created by itay gervash on 14/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SnapKit

class CardViewController: UIViewController {
    
    private lazy var card: UIView = {
       let view = UIView()
        view.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        view.backgroundColor = .white
        return view
    }()
    
    private var cardDistanceFromTop: CGFloat = UIScreen.main.bounds.size.height * 0.5 {
        didSet {
            card.snp.updateConstraints { (update) in
                update.top.equalToSuperview().offset(cardDistanceFromTop)
            }
        }
    }

    private lazy var cardHandle: UIView = {
        let handle = UIView()
        handle.roundCorners(corners: .allCorners, radius: 4)
        handle.backgroundColor = K.colors.aliceBlue
        return handle
    }()
//    
//    private lazy var panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25)
        self.view.addSubview(UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400)))

        setUpView()
        print(self.view.subviews)
        
        
    }
    
    private func setUpView() {
        addSubviews()
        setConstraintsForSubviews()
    }
    
    private func addSubviews() {
        self.view.addSubview(card)
        self.view.addSubview(cardHandle)
        
//        self.view.addGestureRecognizer(panGR)
    }
    
    private func setConstraintsForSubviews() {
        
        card.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(cardDistanceFromTop)
        }
        
        cardHandle.snp.makeConstraints { (make) in
            make.height.equalTo(4 * heightModifier)
            make.width.equalTo(16 * widthModifier)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(6 * heightModifier)
        }
        
    }
    
//    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
//
//        var initialPoint = CGPoint()
//        var currentPoint = CGPoint()
//
//        if recognizer.state == .began {
//            initialPoint = recognizer.location(in: self.view)
//        }
//
//        if recognizer.state != .failed && recognizer.state != .cancelled {
//            currentPoint = recognizer.location(in: self.view)
//
//            let dy = initialPoint.y - currentPoint.y
//            cardDistanceFromTop += dy
//
//            if dy > 400 { self.dismiss(animated: true, completion: nil) }
//        }
//    }

    
}

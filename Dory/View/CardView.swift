//
//  CardView.swift
//  Dory
//
//  Created by itay gervash on 15/10/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    //MARK: - parameters
    
    var panStartPoint = CGPoint()
    
    var backGroundOpacity: CGFloat = 10
    
    lazy var dimmer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    lazy var card: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 16)
        return view
    }()
    
    private lazy var cardHandle: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    
    private lazy var panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    private lazy var dimmerPanGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    
    //MARK: - functions
    
    private func setUpView() {
        self.backgroundColor = .clear

        addSubviews()
        setConstraintsToSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(dimmer)
        self.addSubview(card)
        self.addSubview(cardHandle)
        
        dimmer.addGestureRecognizer(tapGR)
        dimmer.addGestureRecognizer(dimmerPanGR)
        
        card.addGestureRecognizer(panGR)
    }
    
    private func setConstraintsToSubviews() {
        
        dimmer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        card.snp.makeConstraints { (make) in
            guard card.superview != nil else { print("card has no Superview"); return }
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
            make.bottom.equalToSuperview().offset(UIScreen.main.bounds.height * 0.5)
        }
        
        cardHandle.snp.makeConstraints { (make) in
            guard card.superview != nil else { print("card has no Superview"); return }
            make.centerX.equalToSuperview()
            make.height.equalTo(4 * heightModifier)
            make.width.equalTo(36 * heightModifier)
            make.top.equalTo(card.snp.top).offset(16 * widthModifier)
        }
        
    }
    
    func animateViewIn() {
        
        print("animate in")
        
        UIView.animate(withDuration: 0.1) {
            self.dimmer.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: self.backGroundOpacity / 100)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut, animations: {
            self.card.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview()
            }
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateViewOut() {
        
        
        UIView.animate(withDuration: 0.2) {
            self.card.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(UIScreen.main.bounds.height * 0.5)
            }
            self.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveLinear, animations: {
            self.dimmer.backgroundColor = .clear
            self.layoutIfNeeded()
        }) { (success) in
            if success {
                print("success")
                self.removeFromSuperview()
                
            }
        }

        
    }
    
    //gr handlers
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state != .failed {
            self.animateViewOut()
        }
    }
    
    @objc private func handlePan(_ sender: UITapGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizer.State.began) {
            panStartPoint = sender.location(in: self.dimmer)
        }
        
        let currentPoint = sender.location(in: self.dimmer)
        let distanceY = currentPoint.y - panStartPoint.y
        
        //print("pan distance: ", distanceY)
        
        if distanceY > 0 {
            card.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(distanceY)
            }
            
            //change dimmer opacity by pan length
            let opacityModifier = 1 - (distanceY / 270)
            print(opacityModifier, backGroundOpacity * opacityModifier)
            dimmer.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: (backGroundOpacity * opacityModifier) / 100)
        }
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.2) {
                self.card.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview()
                }
                self.layoutIfNeeded()
            }
            
            if distanceY >= 270 {
                self.animateViewOut()
            }
            
        }

    }
    
    //init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setUpView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()
    }
    
}

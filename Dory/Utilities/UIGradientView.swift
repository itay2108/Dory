//
//  UIGradientView.swift
//  Dory
//
//  Created by itay gervash on 23/08/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit

@IBDesignable
class UIGradientView: UIView {
    
    private var gradient: CAGradientLayer?
    private var colors: [Any]?
    
    @IBInspectable var startColor: UIColor?
    
    @IBInspectable var endColor: UIColor?
    
    @IBInspectable var angle: CGFloat = 0
    

    //MARK: - gradient creation
    
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.masksToBounds = true
        return gradient
    }
    
    private func initGradient() {
        
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        
        let gradient = createGradient()
        gradient.masksToBounds = true
        
        self.layer.insertSublayer(gradient, at: 0)
        
        self.gradient = gradient

    }
    
    //MARK: - angle calculations
    
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (abs(x) > abs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }
    
    
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }
    
    //MARK: - redraw methods
    
    override var frame: CGRect {
        didSet {
            updateGradient()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // this is crucial when constraints are used in superviews
        updateGradient()
    }

    // Update an existing gradient
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
            gradient.frame = self.bounds
        }
    }
    
    //MARK: - inits
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initGradient()
    }
    
    //MARK: - prepare for interface builder
    
    override func prepareForInterfaceBuilder() {
           super.prepareForInterfaceBuilder()
           initGradient()
           updateGradient()
       }
    
}

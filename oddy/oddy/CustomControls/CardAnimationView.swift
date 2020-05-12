
//
//  CardAnimationView.swift
//  oddy
//
//  Created by Mostafizur Rahman on 12/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

@IBDesignable class CardAnimationView: CardView {

    
    let gradientLayer = CAGradientLayer()
    var animationGroup:CAAnimationGroup?
    var animationDuration:TimeInterval = 30
    var updateTimer:Timer?
    var endTime: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureGradient() {
        self.gradientLayer.backgroundColor = UIColor.init(rgb: 0x3958a8).cgColor
        self.gradientLayer.locations = [0, 1]
        self.gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        self.gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        self.gradientLayer.colors = [UIColor.magenta.cgColor,
                                     UIColor.systemPink.cgColor]
        self.gradientLayer.borderWidth = super.borderWidth / 2.0
        self.gradientLayer.borderColor = super.borderColor.cgColor
        self.gradientLayer.cornerRadius = super.cornerRadius - self.borderWidth / 2
        self.endTime = Date().addingTimeInterval(self.animationDuration)
        guard let timeLabel = self.viewWithTag(1111) as? LTMorphingLabel else {
            return
        }
        timeLabel.morphingEffect = LTMorphingEffect.evaporate
        var cardBound = super.getBound(inRect: self.bounds)
        cardBound.size.width = 0
        self.gradientLayer.frame = cardBound
        self.layer.insertSublayer(self.gradientLayer, at: 0)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = super.borderPath.cgPath
        self.gradientLayer.masksToBounds = true
        self.gradientLayer.mask = shapeLayer
        self.layer.insertSublayer(self.gradientLayer, at: 0)
        self.createAnimationGroup()
        self.createAnimationTimer()
        self.bringSubviewToFront(timeLabel)
    }
    
    fileprivate func createAnimationTimer(){
        self.updateTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                target: self,
                                                selector: #selector(updateTime),
                                                userInfo: nil, repeats: true)
        self.updateTimer?.tolerance = 0.1
    }
    
    @objc func updateTime() {
        guard let timeLabel = self.viewWithTag(1111) as? LTMorphingLabel else {
            return
        }
        if self.animationDuration > 0 {
            self.animationDuration = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = self.animationDuration.time
        } else {
            timeLabel.text = "00:00"
            self.updateTimer?.invalidate()
        }
    }
    fileprivate func createAnimationGroup(){
        let boundAnimation = CABasicAnimation.init(keyPath: "bounds")
        let positionAnimation = CABasicAnimation.init(keyPath: "position")
        
        positionAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        boundAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        
        boundAnimation.fromValue = NSValue.init(cgRect:
            CGRect(x: 0,
                   y: 0,
                   width: 0,
                   height: self.bounds.height )
        )
        
        boundAnimation.toValue = NSValue.init(cgRect:
            CGRect(x:0,
                   y: 0,
                   width: self.bounds.width ,
                   height: self.bounds.height)
        )
        positionAnimation.fromValue = NSValue.init(cgPoint:
            CGPoint(x: 0,
                    y: self.bounds.size.height/2)
        )
        positionAnimation.toValue = NSValue.init(cgPoint:
                   CGPoint(x: self.bounds.size.width / 2,
                           y: self.bounds.size.height/2)
               )
        
        animationGroup = CAAnimationGroup()
        animationGroup?.isRemovedOnCompletion = false
        positionAnimation.isRemovedOnCompletion = false
        boundAnimation.isRemovedOnCompletion = false
        self.animationGroup?.animations = [boundAnimation, positionAnimation]
        
        self.animationGroup?.duration = CFTimeInterval(self.animationDuration)
        self.animationGroup?.delegate = self
        self.animationGroup?.fillMode = CAMediaTimingFillMode.forwards
        if let _animationGroup = self.animationGroup {
            self.gradientLayer.add(_animationGroup, forKey: "animation")
        }
    }
}


extension CardAnimationView:CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        debugPrint("iko")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
}
extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}

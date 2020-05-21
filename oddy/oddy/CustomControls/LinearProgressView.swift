//
//  LinearProgressView.swift
//  oddy
//
//  Created by Mostafizur Rahman on 22/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class LinearProgressView: UIView, CAAnimationDelegate {
    
    let animationLength:CGFloat = (IAViewAnimation.SCREEN_WIDTH - 24) / 58.0
    
    
    let colorLayer = CAGradientLayer()
    
    
    var rightAnswerCount:Int = 0  {
        didSet {
            self.animateCircleColors(atIndex: rightAnswerCount)
        }
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureAnimation()
    }
    
    
    fileprivate func configureAnimation(){
        
        self.colorLayer.frame = CGRect(x:0,y:0,width:0,
                                       height:self.bounds.size.height )
        
        self.colorLayer.backgroundColor = UIColor.init(rgb: 0x3958a8).cgColor
        colorLayer.locations = [0, 1]
        colorLayer.startPoint = CGPoint(x:0.0, y:0.5)
        colorLayer.endPoint = CGPoint(x:1.0, y:0.5)
        colorLayer.colors = [UIColor.magenta.cgColor, UIColor.systemYellow.cgColor]
        colorLayer.masksToBounds = true
        colorLayer.cornerRadius = self.bounds.height / 2
        
        self.layer.addSublayer(self.colorLayer)
        
    }
    
    
    func animateCircleColors(atIndex index:Int){
        if index > 58 {
            return
        }
        let nextRect = CGRect(x:0,y:0,
                              width:self.animationLength * CGFloat(index),
                              height:self.bounds.size.height)
        let nextPosition = CGPoint(x:nextRect.midX,y:self.bounds.size.height/2)
        
        
        let animationBounds = CABasicAnimation.init(keyPath: "bounds")
        let animationPosition = CABasicAnimation.init(keyPath: "position")
        animationPosition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animationBounds.fromValue = colorLayer.bounds
        animationBounds.toValue = nextRect
        animationPosition.fromValue = colorLayer.position
        animationPosition.toValue = nextPosition
        let groupAnimation = CAAnimationGroup()
        groupAnimation.isRemovedOnCompletion = false
        animationPosition.isRemovedOnCompletion = false
        animationBounds.isRemovedOnCompletion = false
        groupAnimation.animations = [animationBounds, animationPosition]
        groupAnimation.duration = 0.6
        groupAnimation.fillMode = CAMediaTimingFillMode.forwards
        groupAnimation.delegate = self
        self.colorLayer.add(groupAnimation, forKey: "colorChange")
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let _group = anim as? CAAnimationGroup{
                for _anim in _group.animations ?? [] {
                    if let _basicAnim = _anim as? CABasicAnimation {
                        if let _toRect = _basicAnim.toValue as? CGRect {
                            self.colorLayer.frame = _toRect
                        } else if let _toPosition = _basicAnim.toValue as? CGPoint {
                            self.colorLayer.position = _toPosition
                        }
                    }
                }
            }
            self.colorLayer.layoutIfNeeded()
            self.colorLayer.setNeedsLayout()
            self.colorLayer.removeAllAnimations()
//            self.colorLayer.frame = anim.
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let _path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2)
        context.addPath(_path.cgPath)
        context.clip()
        let gradLocationsNum = 2
        let gradLocations:[CGFloat] = [1.0, 0]
        let gradColors:[CGFloat] = [0.3, 0.3, 0.3,1.0,0.8, 0.8,0.8,1.0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let gradient = CGGradient(colorSpace: colorSpace,
                                        colorComponents: gradColors,
                                        locations: gradLocations,
                                        count: gradLocationsNum) else {
                                            return
        }
        
        context.drawLinearGradient(gradient, start: CGPoint(x:0, y:rect.midY),
                                   end: CGPoint(x:rect.size.width, y:rect.midY),
                                   options: .drawsAfterEndLocation)
    }

}

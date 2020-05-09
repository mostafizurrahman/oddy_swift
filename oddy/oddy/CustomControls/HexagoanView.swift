//
//  HexagoanView.swift
//  EyeVisionTestPuzzle
//
//  Created by Mostafizur Rahman on 3/5/20.
//  Copyright © 2020 image-app. All rights reserved.
//

import UIKit

class HexagoanView: UIView,CAAnimationDelegate {
    @IBOutlet var titleLabel:LTMorphingLabel?
    
    fileprivate var gl:CAGradientLayer?

    var colorAnimation : CABasicAnimation? = CABasicAnimation(keyPath: "colors")
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    fileprivate func setAnimatedLabel(){
        self.titleLabel?.stop()
        self.titleLabel?.removeFromSuperview()
        self.titleLabel = LTMorphingLabel.init()
        self.titleLabel?.bounds = self.bounds
        self.titleLabel?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.bounds.size)
        self.titleLabel?.backgroundColor = UIColor.clear
        guard let _label = self.titleLabel else {return}
        self.addSubview(_label)
        _label.font = UIFont(name:"Copperplate-Bold", size: 12.0)
        _label.textColor = UIColor.white
        _label.textAlignment = NSTextAlignment.center
        _label.setNeedsLayout()
        _label.morphingEffect = LTMorphingEffect.anvil
        _label.start()
        _label.pause()
        _label.text = ["ODD LETTERS", "ODD COLORS",
                       "COLOR BLIND?", "LEARN!!!"][self.tag]
        _label.updateProgress(progress: 0.0)
        _label.unpause()
        
    }

    
    func setLayers(){
        let rect = self.bounds
        let path = UIBezierPath()
        let width: CGFloat = rect.width
        let height = width*1.1
        path.move(
            to: CGPoint(
                x: width * 0.95,
                y: height * (0.20 + HexagonParameters.adjustment)
            )
        )
        
        HexagonParameters.points.forEach {
            path.addLine(
                to: .init(
                    x: width * $0.useWidth.0 * $0.xFactors.0,
                    y: height * $0.useHeight.0 * $0.yFactors.0
                )
            )
            
            path.addQuadCurve(
                to: .init(
                    x: width * $0.useWidth.1 * $0.xFactors.1,
                    y: height * $0.useHeight.1 * $0.yFactors.1
                ),
                controlPoint: .init(
                    x: width * $0.useWidth.2 * $0.xFactors.2,
                    y: height * $0.useHeight.2 * $0.yFactors.2
                )
            )
        }
        self.gl = CAGradientLayer()
        self.gl?.colors = [UIColor.magenta.cgColor, UIColor.red.cgColor]
        self.gl?.locations = [0.0, 1.0]
        self.gl?.startPoint = CGPoint(x:0, y:0.5)
        self.gl?.endPoint = CGPoint(x:1, y:0.5)
        self.gl?.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        if let _layer = self.gl {
            self.layer.insertSublayer(_layer, at: 0)
        }
        path.close()
        let mask = CAShapeLayer()
        mask.path = path.cgPath

        self.layer.mask = mask
        self.layer.masksToBounds = true
        self.animateLayer()
        self.setAnimatedLabel()
    }
    
    func clearAnimation(){
        
        if let _layer = self.gl {
            _layer.removeAllAnimations()
            _layer.removeFromSuperlayer()
            self.gl?.removeAnimation(forKey: "animateGradient")
            self.gl = nil
            self.colorAnimation?.delegate = nil
            self.colorAnimation = nil
        }
    }
    
    fileprivate func animateLayer(){
        guard let _layer = self.gl else {return}
        let fromColors = [ randomRed(), randomMagenta()]
        colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation?.fromValue = fromColors
        colorAnimation?.toValue = _layer.colors
        colorAnimation?.duration = 2.50
        colorAnimation?.delegate = self
        colorAnimation?.autoreverses = false
        colorAnimation?.fillMode = CAMediaTimingFillMode.forwards
        colorAnimation?.timingFunction =
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        if let _anim = self.colorAnimation {
            _anim.delegate = self
            self.gl?.add(_anim, forKey:"animateGradient")
        }
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animateLayer()
        self.setAnimatedLabel()
    }
    
    
    fileprivate func randomRed()->CGColor{
        return UIColor.init(red: CGFloat(Float.random(in: 0 ..< 1.0)),
                            green: CGFloat(Float.random(in: 0 ..< 1.0)),
                            blue: CGFloat(Float.random(in: 0 ..< 1.0)),
                            alpha: 1.0).cgColor
    }
    
    fileprivate func randomMagenta()->CGColor{
        return UIColor.init(red: CGFloat(Float.random(in: 0 ..< 1.0)),
                            green: CGFloat(Float.random(in: 0 ..< 1.0)),
                            blue: CGFloat(Float.random(in: 0 ..< 1.0)),
                            alpha: 1.0).cgColor
    }

}
struct HexagonParameters {
    struct Segment {
        let useWidth: (CGFloat, CGFloat, CGFloat)
        let xFactors: (CGFloat, CGFloat, CGFloat)
        let useHeight: (CGFloat, CGFloat, CGFloat)
        let yFactors: (CGFloat, CGFloat, CGFloat)
    }
    
    static let adjustment: CGFloat = 0.05
    
    static let points = [
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (0.60, 0.40, 0.50),
            useHeight: (1.00, 1.00, 0.00),
            yFactors:  (0.05, 0.05, 0.00)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 0.00),
            xFactors:  (0.05, 0.00, 0.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.20 + adjustment, 0.30 + adjustment, 0.25 + adjustment)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 0.00),
            xFactors:  (0.00, 0.05, 0.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.70 - adjustment, 0.80 - adjustment, 0.75 - adjustment)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (0.40, 0.60, 0.50),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.95, 0.95, 1.00)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (0.95, 1.00, 1.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.80 - adjustment, 0.70 - adjustment, 0.75 - adjustment)
        ),
        Segment(
            useWidth:  (1.00, 1.00, 1.00),
            xFactors:  (1.00, 0.95, 1.00),
            useHeight: (1.00, 1.00, 1.00),
            yFactors:  (0.30 + adjustment, 0.20 + adjustment, 0.25 + adjustment)
        )
    ]
}



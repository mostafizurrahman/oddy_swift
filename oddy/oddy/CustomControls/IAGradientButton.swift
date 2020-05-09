//
//  IAGradientButton.swift
//  oddy
//
//  Created by Mostafizur Rahman on 8/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

@IBDesignable class IAGradientButton: UIButton {
    @IBInspectable var shadowColor:UIColor = UIColor.black {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.white {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowRadius:CGFloat = 0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOpcaity:Float = 0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let gradientContext = UIGraphicsGetCurrentContext() else {
            return
        }
        let gradientPath = UIBezierPath(roundedRect: rect, cornerRadius: self.cornerRadius)
        gradientPath.close()
        let locationNumber = 2
        let gradientLocations:[CGFloat] = [0.0, 1.0]
        let gradientColors:[CGFloat] = self.getColorComponents()
//        gradientColors.append(contentsOf: self.rightGradientColor.getComponents())
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let gradient = CGGradient.init(colorSpace: colorSpace,
                                             colorComponents: gradientColors,
                                             locations: gradientLocations,
                                             count: locationNumber) else { return  }
        gradientContext.setLineWidth(self.borderWidth)
        gradientContext.setStrokeColor(self.borderColor.cgColor)
        gradientContext.addPath(gradientPath.cgPath)
        gradientContext.clip()
        self.draw(colorGradient:gradient, inContext:gradientContext, inRect:rect )
        gradientContext.addPath(gradientPath.cgPath)
        gradientContext.strokePath()
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpcaity
        self.layer.shadowRadius = self.shadowRadius
    }
    
    func getColorComponents()->[CGFloat]{
        return []
    }
    
    func draw(colorGradient gradient:CGGradient,
              inContext gradientContext:CGContext,
              inRect rect:CGRect) {
        
    }

}

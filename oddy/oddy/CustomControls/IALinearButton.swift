//
//  LinearButton.swift
//  oddy
//
//  Created by Mostafizur Rahman on 8/5/20.
//  Copyright © 2020 IMAGE-APP. All rights reserved.
//

import UIKit

//MARK: LinearGradientButton
//is a button class with left to right gradient inside
//It is a rectangle button. shadow, left gradient color
//right gradient color can be set

@IBDesignable class IALinearButton: IAGradientButton {

    
    @IBInspectable var leftGradientColor:UIColor = UIColor.magenta {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var rightGradientColor:UIColor = UIColor.red {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//
//        guard let linearContext = UIGraphicsGetCurrentContext() else {
//            return
//        }
//        let linearPath = UIBezierPath(roundedRect: rect, cornerRadius: self.cornerRadius)
//        linearPath.close()
//        let locationNumber = 2
//        let gradientLocation:[CGFloat] = [0.0, 1.0]
//        var gradientColors:[CGFloat] = self.leftGradientColor.getComponents()
//        gradientColors.append(contentsOf: self.rightGradientColor.getComponents())
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        guard let linearGradient = CGGradient.init(colorSpace: colorSpace,
//                                                   colorComponents: gradientColors,
//                                                   locations: gradientLocation,
//                                                   count: locationNumber) else { return  }
//
//        linearContext.setLineWidth(self.borderWidth)
//        linearContext.setStrokeColor(self.borderColor.cgColor)
//        linearContext.addPath(linearPath.cgPath)
//        linearContext.clip()
//        linearContext.drawLinearGradient(linearGradient,
//                                         start: CGPoint(x: 0, y: rect.midY),
//                                         end: CGPoint(x: rect.width, y: rect.midY),
//                                         options: CGGradientDrawingOptions.drawsAfterEndLocation)
//        linearContext.strokePath()
//
//    }
    
    override func getColorComponents()->[CGFloat]{
        var gradientColors:[CGFloat] = self.leftGradientColor.getComponents()
        gradientColors.append(contentsOf: self.rightGradientColor.getComponents())
        return gradientColors
    }
    
    override func draw(colorGradient gradient:CGGradient,
                       inContext gradientContext:CGContext,
                       inRect rect:CGRect){
        gradientContext.drawLinearGradient(gradient,
                                           start: CGPoint(x: 0, y: rect.midY),
                                           end: CGPoint(x: rect.width, y: rect.midY),
                                           options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }

}

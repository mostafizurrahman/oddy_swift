//
//  IAVGradientBullet.swift
//  oddy
//
//  Created by Mostafizur Rahman on 11/6/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class IAVGradientBullet: UIView {

    var selectionColor = UIColor.black.withAlphaComponent(0.8)
    private var twoGradient = false
    private var startColor:UIColor = UIColor.systemPink
    private var endColor:UIColor = UIColor.gray
    func setGradient(color:UIColor){
        self.startColor = color
        self.endColor = color
        self.twoGradient = false
        self.setNeedsDisplay()
    }
    
    func setStart(color:UIColor, endColor ecolor:UIColor){
        self.startColor = color
        self.endColor = ecolor
        self.twoGradient = true
        self.setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        // Draw A Gradient from yellow to Orange
        let colors = [self.startColor.cgColor, self.endColor.cgColor]
        let myColorspace = CGColorSpaceCreateDeviceRGB()
        guard let myGradient = CGGradient.init(colorsSpace: myColorspace,
                                               colors: colors as CFArray,
                                               locations: nil)
                                        else {return}
        let gradCenter = CGPoint(x:rect.midX, y: rect.midY);
        let gradRadius = min(self.bounds.size.width , self.bounds.size.height) ;
        let options = CGGradientDrawingOptions.drawsBeforeStartLocation
        context.drawRadialGradient(myGradient,
                                   startCenter: gradCenter,
                                   startRadius: 0.0,
                                   endCenter: gradCenter,
                                   endRadius: gradRadius,
                                   options: options)
        
    }
    

}

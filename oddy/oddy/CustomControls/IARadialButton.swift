//
//  GradientButton.swift
//  Puzzle Eye Vision Power Test
//
//  Created by Mostafizur Rahman on 6/7/18.
//  Copyright © 2018 image-app. All rights reserved.
//

import UIKit


//MARK: RadialButton
//is a button class with radial gradient inside
//It is a square button. shadow, inncer radial color
//Outre radial color can be set



@IBDesignable class IARadialButton: IAGradientButton {
    
    
    @IBInspectable public var outerRaidalColor:UIColor = .red{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var innerRadialColor:UIColor = .gray{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

 
    
    override func getColorComponents()->[CGFloat]{
        var gradientColors:[CGFloat] = outerRaidalColor.getComponents()
        gradientColors.append(contentsOf: innerRadialColor.getComponents())
        return gradientColors
    }
    
    override func draw(colorGradient gradient:CGGradient,
                       inContext gradientContext:CGContext,
                       inRect rect:CGRect){
        
        gradientContext.drawRadialGradient(gradient,
                                           startCenter: CGPoint(x:rect.midX, y:rect.midY),
                                           startRadius: rect.size.width / 2,
                                           endCenter: CGPoint(x:rect.midX, y:rect.midY),
                                           endRadius: 0,
                                           options: .drawsAfterEndLocation)
    }
}

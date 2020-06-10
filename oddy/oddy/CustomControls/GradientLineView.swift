//
//  GradientLineView.swift
//  EyeVisionTestPuzzle
//
//  Created by Mostafizur Rahman on 6/13/18.
//  Copyright © 2018 image-app. All rights reserved.
//

import UIKit

@IBDesignable
public class GradientLineView: UIView {

    fileprivate var gl:CAGradientLayer!
    @IBInspectable public var ishorizontalGradient: Bool = false
    @IBInspectable public var startColor:UIColor = .magenta
    @IBInspectable public var endColor:UIColor = .gray
    public override init(frame: CGRect) {
        super.init(frame: frame)
//        self.setGradientLayer()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.setGradientLayer()
    }
    
    fileprivate func setGradientLayer(){
 
        
        self.gl = CAGradientLayer()
        
        
        
        if self.ishorizontalGradient{
            self.gl.colors = [startColor.cgColor, endColor.cgColor]
            self.gl.locations = [0.0, 1.0]
            self.gl.startPoint = CGPoint(x:0, y:0.5)
            self.gl.endPoint = CGPoint(x:1, y:0.5)
        } else {
            self.gl.colors = [ endColor.cgColor, startColor.cgColor]
            
            self.gl.locations = [0.0, 1.0]
            self.gl.startPoint = CGPoint(x:0.5, y:0.0)
            self.gl.endPoint = CGPoint(x:0.50, y:1.0)
        }
        self.gl.frame = self.bounds
        self.layer.insertSublayer(self.gl, at: 0)
    }
    

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setGradientLayer()
        // Drawing code
    }


}

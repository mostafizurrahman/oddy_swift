//
//  ColorExtension.swift
//  oddy
//
//  Created by Mostafizur Rahman on 8/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ColorExtension: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    convenience init(random:Bool){
        let r = CGFloat(Double(arc4random_uniform(256)) / 255.0)
        let g = CGFloat(Double(arc4random_uniform(256)) / 255.0)
        let b = CGFloat(Double(arc4random_uniform(256)) / 255.0)
        //        let a = Double(arc4random_uniform(255)) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    convenience init(baseColor:UIColor, difference:CGFloat){
        var a:CGFloat = 0
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        
      
            
            baseColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        r *= 255.0
        g *= 255.0
        b *= 255.0
            let minimum = min(b, min(r, g))
            
            if difference > minimum {
                
                r += difference
                g += difference
                b += difference

                
            } else {
                let maximum = max(b, max(r, g))
                if maximum + difference < 255.0 {


                    r += difference
                    g += difference
                    b += difference


                } else {
                
                    r -= difference
                    g -= difference
                    b -= difference
                }
            }
            self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    func getComponents()->[CGFloat]{
        var alpha:CGFloat = 0
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return [red, green, blue, alpha]
    }
}

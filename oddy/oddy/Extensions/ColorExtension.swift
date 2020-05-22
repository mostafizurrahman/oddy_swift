//
//  ColorExtension.swift
//  oddy
//
//  Created by Mostafizur Rahman on 8/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

struct RGB {
    let red:Double
    let green:Double
    let blue:Double
}

class ColorExtension: UIColor {

    
    
    
    
    
}
extension UIColor {
    static  func clamp(_ value:Double)->Double {
        return value > 255 ? 255 : value < 0 ? 0 : value
    }
    static func transform(color:RGB, hue:Double)->RGB {
        
        let _red = Double(color.red)
        let _green = Double(color.green)
        let _blue = Double(color.blue)
        let _cosA = cos(hue * 3.14159265 / 180.0)
        let _sinA = sin(hue * 3.14159265 / 180.0)
        let _root = Double(sqrtf(1.0 / 3.0))
        let _00 = _cosA + (1.0 - _cosA) / 3.0
        let _01 = 1.0 / 3.0 * (1.0 - _cosA) - _root * _sinA
        let _02 = 1.0 / 3.0 * (1.0 - _cosA) + _root * _sinA
        let _10 = 1.0 / 3.0 * (1.0 - _cosA) + _root * _sinA
        let _11 = _cosA + 1.0 / 3.0 * (1.0 - _cosA)
        let _12 = 1.0 / 3.0 * (1.0 - _cosA) - _root * _sinA
        let _20 = 1.0 / 3.0 * (1.0 - _cosA) - _root * _sinA
        let _21 = 1.0 / 3.0 * (1.0 - _cosA) + _root * _sinA
        let _22 = _cosA + 1.0 / 3.0 * (1.0 - _cosA)

        let matrix =  [[_00, _01, _02],
                       [_10, _11, _12],
                       [_20, _21, _22]];
        
        let red = clamp(
            _red * matrix[0][0] +
                _green * matrix[0][1] +
                _blue * matrix[0][2])
        let green = clamp(
            _red * matrix[1][0] +
                _green * matrix[1][1] +
                _blue * matrix[1][2])
        let blue = clamp(
            _red * matrix[2][0] +
                _green * matrix[2][1] +
                _blue * matrix[2][2])
        
        
        
        
        let rgb = RGB(red: red, green: green, blue: blue)
        return rgb
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
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
    
    convenience init(baseColor:UIColor, difference:Double){
        var red:CGFloat = 0,
        green:CGFloat = 0,
        blue:CGFloat = 0,
        alpha:CGFloat = 0
        baseColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let _rgb = RGB(red: Double(red * 255.0),
                       green: Double(green * 255.0),
                       blue: Double(blue * 255.0))
        let rgb = UIColor.transform(color: _rgb, hue: difference)
        
        self.init(red: CGFloat(rgb.red) / 255.0,
                  green: CGFloat(rgb.green) / 255.0,
                  blue: CGFloat(rgb.blue) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(baseColor:UIColor, isGreen:Bool){
        var red:CGFloat = 0,
        green:CGFloat = 0,
        blue:CGFloat = 0,
        alpha:CGFloat = 0
        baseColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if isGreen {
            self.init(red: (red / (1.0 - red))/20.0,
                      green: green+0.5,
            blue: (blue / (1.0 - blue))/20.0,
            alpha: 1.0)
        } else {
            self.init(red: red+0.5,
            green: (green / (1.0 - green))/20.0,
            blue: (blue / (1.0 - blue))/20.0,
            alpha: 1.0)
        }
    }
    
    
    func getComponents()->[CGFloat]{
        var alpha:CGFloat = 0
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return [red, green, blue, alpha]
    }
    
    
    convenience init(baseColor:UIColor, difference:CGFloat, hardcore:Bool){
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
}

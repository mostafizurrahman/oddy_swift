//
//  CardView.swift
//  oddy
//
//  Created by Mostafizur Rahman on 10/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit
enum CornerType:Int{
    case roundLeftBottom = 1
    case roundRightTop = 2
    case roundLeftTop = 3
    case roundRightBottom = 4
    case roundNone = 5
}
@IBDesignable class CardView: UIView {
    
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
    
    @IBInspectable var cardInnerColor:UIColor = UIColor.systemPink {
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
    
    var cornerLeftTop:CornerType = .roundNone
    @IBInspectable var _cornerLeftTop:Int = 5 {
        didSet{
            self.cornerLeftTop = CornerType.init(rawValue: _cornerLeftTop) ?? .roundNone
            self.setNeedsDisplay()
        }
    }
    
    
    var cornerRightTop:CornerType = .roundNone
    @IBInspectable  var _cornerRightTop:Int = 5 {
        didSet{
            self.cornerRightTop = CornerType.init(rawValue: _cornerRightTop) ?? .roundNone
            self.setNeedsDisplay()
        }
    }
    
    var cornerRightBottom:CornerType = .roundNone
    @IBInspectable  var _cornerRightBottom:Int = 5 {
        didSet{
            self.cornerRightBottom = CornerType.init(rawValue: _cornerRightBottom) ?? .roundNone
            self.setNeedsDisplay()
        }
    }
    
    var cornerLeftBottom:CornerType = .roundNone
    @IBInspectable var _cornerLeftBottom:Int = 5 {
        didSet{
            self.cornerLeftBottom = CornerType.init(rawValue: _cornerLeftBottom) ?? .roundNone
            self.setNeedsDisplay()
        }
    }
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
     
        guard let cardContext = UIGraphicsGetCurrentContext() else {return}
        
        cardContext.setStrokeColor(self.borderColor.cgColor)
        cardContext.setLineWidth(self.borderWidth)
        let cardPath = self.getCardPath(forRect: rect)
        cardContext.addPath(cardPath.cgPath)
        cardContext.setFillColor(self.cardInnerColor.cgColor)
        cardContext.fillPath(using: CGPathFillRule.evenOdd)
        let borderPath = self.getCardPath(forRect: CGRect(origin: CGPoint(x: self.borderWidth,
                                                                          y: self.borderWidth),
                                                          size: CGSize(width: rect.width ,
                                                                       height: rect.height )))
        cardContext.addPath(cardPath.cgPath)
        cardContext.clip()
        cardContext.addPath(borderPath.cgPath)
        cardContext.strokePath()
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpcaity
        self.layer.shadowRadius = self.shadowRadius
    }
    
    
    fileprivate func getCardPath(forRect rect:CGRect)->UIBezierPath{
        let cardPath = UIBezierPath()
        if self.cornerLeftTop == .roundLeftTop {
            let origin = CGPoint(x: 0, y: self.cornerRadius)
            cardPath.move(to: origin)
            let originTop = CGPoint(x: self.cornerRadius, y: 0)
            let controlPoint = CGPoint.zero
            cardPath.addQuadCurve(to: originTop, controlPoint: controlPoint)
        } else {
            cardPath.move(to: .zero)
        }
        cardPath.addLine(to: CGPoint(x: rect.width - self.cornerRadius, y: 0))
        if self.cornerRightTop == .roundRightTop {
            let originRight = CGPoint(x: rect.width, y: self.cornerRadius)
            let controlPoint = CGPoint(x: rect.width, y: 0)
            cardPath.addQuadCurve(to: originRight, controlPoint: controlPoint)
        } else {
            cardPath.addLine(to: CGPoint(x: rect.width, y: 0))
        }
        cardPath.addLine(to: CGPoint(x: rect.width, y: rect.height - self.cornerRadius))
        if self.cornerRightBottom == .roundRightBottom {
            let originBottom = CGPoint(x: rect.width - self.cornerRadius, y: rect.height)
            let controlPoint = CGPoint(x: rect.width, y: rect.height)
            cardPath.addQuadCurve(to: originBottom, controlPoint: controlPoint)
        } else {
            cardPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        }
        cardPath.addLine(to: CGPoint(x: self.cornerRadius, y: rect.height))
        if self.cornerLeftBottom == .roundLeftBottom {
            let originLeft = CGPoint(x: 0, y: rect.height - self.cornerRadius)
            let controlPoint = CGPoint(x: 0, y: rect.height)
            cardPath.addQuadCurve(to: originLeft, controlPoint: controlPoint)
        } else {
            cardPath.addLine(to: CGPoint(x: 0, y: rect.height))
        }
        cardPath.addLine(to: CGPoint(x: 0, y: self.cornerRadius))
        if self.cornerLeftTop != .roundLeftTop {
            cardPath.addLine(to: CGPoint(x: 0, y: 0))
        }
        cardPath.close()
        return cardPath
    }

}

//
//  IAViewAnimatiion.swift
//  oddy
//
//  Created by Mostafizur Rahman on 8/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class IAViewAnimation {
    
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    static let SCREEN_BOUND = UIScreen.main.bounds
    static let SCREEN_SIZE = UIScreen.main.bounds.size
    static let SCREEN_WIDTH =  UIScreen.main.bounds.width
    static let SCREEN_HEIGHT =  UIScreen.main.bounds.height
    
    
    static func animate(view:UIView,
                        shouldVisible visible:Bool = true,
                        onCompleted:CompletionHandler? = nil){
        
        if view.superview == nil {
            if let _topController = UIApplication.shared.topViewController() {
                _topController.view.addSubview(view)
            }
        }
        view.layer.opacity = visible ? 0.0 : 1.0
        view.layer.transform = visible ?
            CATransform3DMakeScale(1.3, 1.3, 1.0) :
            view.layer.transform
//        let transform = view.layer.transform
        let animationOption =
            UIView.AnimationOptions.curveEaseInOut
            view.isHidden = false
        UIView.animate(withDuration: 0.45,
                       delay: 0.0,
                       options:animationOption,
                       animations: {
                        view.layer.opacity =  visible ? 1.0 : 0.0
                        view.layer.transform = visible ?
                            CATransform3DMakeScale(1, 1, 1) :
                            CATransform3DConcat(view.layer.transform,
                                                CATransform3DMakeScale(0.6, 0.6, 1.0))
        }) { (_finished) in
            view.layer.displayIfNeeded()
            view.layer.layoutIfNeeded()
            onCompleted?(_finished)
        }
    }

    static func createParticles(forRect rect:CGRect)->CAEmitterLayer {
        
        let particleEmitter = CAEmitterLayer()
        particleEmitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height)
        particleEmitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
        particleEmitter.emitterSize = rect.size
        let red = makeEmitterCell(color: UIColor.red)
        let green = makeEmitterCell(color: UIColor.green)
        let blue = makeEmitterCell(color: UIColor.blue)
        let pink = makeEmitterCell(color: UIColor.systemPink)
        
        let yellow = makeEmitterCell(color: UIColor.systemYellow)

        particleEmitter.emitterCells = [red, green, blue, pink, yellow]

        return particleEmitter
    }
    
    static func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.color = color.cgColor
        cell.spin = 2
        cell.spinRange = 6
        cell.lifetime = 5.5
        cell.birthRate = 10
        cell.blueRange = 0.15
        cell.alphaRange = 0.4
        cell.velocity = 10
        cell.velocityRange = 300
        cell.scale = 0.4
        cell.scaleRange = 1.3
        cell.emissionRange = CGFloat.pi / 2
        cell.emissionLongitude = CGFloat.pi
        cell.yAcceleration = -70
        cell.scaleSpeed = -0.1
        cell.alphaSpeed = -0.05
        cell.contents = UIImage(named: "Smoke")?.cgImage
        return cell
    }
    
    
    
    static func invisible(toView _view:UIView,onCompleted:CompletionHandler? = nil){
        let currentTransform = _view.layer.transform
        _view.layer.opacity = 1.0
        UIView.animate(withDuration: 0.4, animations: {
            _view.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1.0));
        }) { (_finished) in
            onCompleted?(_finished)
        }
//        [UIView animateWithDuration:ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^ {
//            view_to_animate.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
//            view_to_animate.layer.opacity = 0.0f;
//        } completion:^(BOOL finished) {
//            view_to_animate.hidden = YES;
//            completion_block(finished);
//        }];
    }
}

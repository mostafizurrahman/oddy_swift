//
//  OddColorViewController.swift
//  oddy
//
//  Created by Mostafizur Rahman on 20/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class OddColorViewController: UIViewController {

    typealias IAV = IAViewAnimation
    typealias GM = GameManager
    
    @IBOutlet weak var countDownLabel: LTMorphingLabel!
    @IBOutlet weak var boardHeightLayout:NSLayoutConstraint!
    @IBOutlet weak var cardAnimationView: CardAnimationView!
    @IBOutlet weak var boardView:CardView!
    @IBOutlet weak var linearProgressView:LinearProgressView!
    @IBOutlet weak var skipLabel: UILabel!
    @IBOutlet weak var animalLabel: UILabel!
    
    let gameManager = GM.shared
    var isGameOver = false
    var dimension = 2
    var coinCounter = 0
    var rightColorIndex = -1
    var skipCount = 3
    override var prefersStatusBarHidden: Bool {
           return true
       }
    
    
    
    @IBAction func exitOddColor(_ sender: IARadialButton) {
        self.cardAnimationView.removeAnimations()
        if let _navigator = self.navigationController {
            _navigator.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.skipLabel.layer.cornerRadius = self.skipLabel.frame.width / 2
        self.skipLabel.layer.borderColor = UIColor.systemPink.cgColor
        self.skipLabel.layer.borderWidth = 4
        self.skipLabel.layer.masksToBounds = true
        self.linearProgressView.bringSubviewToFront(self.skipLabel)
        self.gameManager.writeAnserCount = 0
        self.gameManager.coinCounter = 0
        self.gameManager.timeCounter = 31
        let _out = self.boardView.frame.origin.x * 2
        self.boardHeightLayout.constant = IAV.SCREEN_WIDTH - _out
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.cardAnimationView.animationDelegate == nil {
            self.addColorViews()
            self.cardAnimationView.configureGradient(delegate: self)
            self.cardAnimationView.startAnimation(withDuration: 30)
        }
    }
    
    
    
    fileprivate func changeColorViews(){
        self.gameManager.setColorTimer()
        self.cardAnimationView.startAnimation(withDuration: self.gameManager.timeCounter)
        self.rightColorIndex = Int.random(in: 0...self.dimension*self.dimension-1)
        debugPrint(self.rightColorIndex)
        let (_sourceColor, _differentColor) = self.gameManager.createColors()
        for _view in self.boardView.subviews {
            if let _colorView = _view as? CardView {
                let originalFrame = _colorView.frame
                var _colorViewFrame = _colorView.frame
                _colorViewFrame.origin.x = -IAV.SCREEN_WIDTH
                UIView.animate(withDuration: 0.35, animations: {
                    _colorView.frame = _colorViewFrame
                }) { (_finished) in
                    _colorViewFrame.origin.x = IAV.SCREEN_WIDTH
                    _colorView.frame = _colorViewFrame
                    _colorView.cardInnerColor =
                        self.rightColorIndex == _colorView.tag ?
                            _differentColor : _sourceColor
                    UIView.animate(withDuration: 0.4) {
                        _colorView.frame = originalFrame
                    }
                }
            }
        }
    }
    
    
    fileprivate func onCorrectAnswerGiven(){
        self.gameManager.writeAnserCount += 1
        self.animalLabel.text = self.gameManager.getAnimalName()
        let _dimension = self.gameManager.getBoxDimension()
        if _dimension != self.dimension {
            self.dimension = _dimension
            for _view in self.boardView.subviews {
                var originalFrame = _view.frame
                originalFrame.origin.x = -(IAV.SCREEN_WIDTH + _view.bounds.width)
                UIView.animate(withDuration: 0.4, animations: {
                    _view.frame = originalFrame
                }) { (_finished) in
                    _view.removeFromSuperview()
                }
            }
            self.addColorViews()
        } else {
            self.changeColorViews()
        }
        
        self.coinCounter += self.gameManager.getColorCoin()
        self.linearProgressView.animateCircleColors(atIndex:
            self.gameManager.writeAnserCount)
    }
    
    fileprivate func addColorViews(){
        
        let _space:CGFloat = 10
        let _fDimension = CGFloat(self.dimension)
        let _width:CGFloat = (self.boardView.frame.width - (_space * (_fDimension + 1.0))) / _fDimension
        
        let _size = CGSize(width: _width, height: _width)
        var _orgY = _space
        self.rightColorIndex = Int.random(in: 0...self.dimension*self.dimension-1)
        let (_sourceColor, _differentColor) = self.gameManager.createColors()
        for i in 0...self.dimension - 1{
            var _orgX:CGFloat = _space
            for j in 0...self.dimension - 1{
                let _viewID =  i * self.dimension + j
                let _colorViewRect = CGRect(origin: CGPoint(x: _orgX, y: _orgY),
                                            size: _size)
                let _initialRect = CGRect(origin: CGPoint(x: IAV.SCREEN_WIDTH, y: _orgY),
                                          size: _size)
                let _colorView = CardView(frame: _initialRect)
                self.boardView.addSubview(_colorView)
                _colorView.backgroundColor = UIColor.clear
                _colorView.layer.backgroundColor = UIColor.clear.cgColor
                _colorView.tag = _viewID
                _colorView._cornerLeftTop = 1
                _colorView._cornerRightTop = 1
                _colorView._cornerLeftBottom = 1
                _colorView._cornerRightBottom = 1
                _colorView.shadowOpcaity = 0.2
                _colorView.shadowRadius = 4
                _colorView.shadowColor = UIColor.black
                _colorView.cornerRadius = 8
                _colorView.cardInnerColor =
                    self.rightColorIndex == _viewID ?
                    _differentColor : _sourceColor
                UIView.animate(withDuration: 0.4, animations: {
                    _colorView.frame = _colorViewRect
                    _colorView.originX = _orgX
                }) { (_finished) in
                    _colorView.setNeedsDisplay()
                }
                _orgX = _orgX + _width + _space
                
            }
            _orgY = _orgY + _width + _space
        }
    }
    
    
    @IBAction func skipColorCombinations(_ sender: Any) {
        if self.isGameOver {
            self.openGameOverDialog()
        } else if self.skipCount > 0 {
            self.skipCount -= 1
            self.skipLabel.text = "\(self.skipCount)"
            self.changeColorViews()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let _touch = touches.first {
            let _location = _touch.location(in: self.boardView)
            let _boardLocation = _touch.location(in: self.view)
            if self.boardView.frame.contains(_boardLocation) && !self.isGameOver{
                self.isGameOver = true
                for _view in self.boardView.subviews {
                    if _view.frame.contains(_location){
                        if self.rightColorIndex == _view.tag {
                            self.onCorrectAnswerGiven()
                            self.isGameOver = false
                        } else if let _colorView = _view as? CardView {
                            _colorView.borderWidth = 8
                            _colorView.borderColor = UIColor.init(baseColor:
                                _colorView.cardInnerColor, isGreen: false)
                            if let _rightView = self.boardView
                                .subviews
                                .filter({$0.tag == self.rightColorIndex})
                                .first as? CardView {
                                _rightView.borderWidth = 8
                                _rightView.borderColor = UIColor.init(baseColor:
                                _colorView.cardInnerColor, isGreen: true)
                            }
                        }
                    }
                }
            }
        }
        if self.isGameOver {
            
            for _anim in self.cardAnimationView.animationGroup?.animations ?? [] {
                    if let _basicAnim = _anim as? CABasicAnimation {
                        if let _toRect = _basicAnim.toValue as? CGRect {
                            self.cardAnimationView.gradientLayer.frame = _toRect
                        } else if let _toPosition = _basicAnim.toValue as? CGPoint {
                            self.cardAnimationView.gradientLayer.position = _toPosition
                        }
                    }
                }
            self.cardAnimationView.removeAnimations()
            self.openGameOverDialog()
        }
    }

}





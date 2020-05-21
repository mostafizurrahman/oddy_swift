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
    
    let gameManager = GM.shared
    
    var dimension = 6
    
    
    
    override var prefersStatusBarHidden: Bool {
           return true
       }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.boardHeightLayout.constant = IAV.SCREEN_WIDTH - 48
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
    
    
    
    fileprivate func removeColorViews(){
        for _view in self.boardView.subviews {
            if let _colorView = _view as? CardView {
                var _colorViewFrame = _colorView.frame
                _colorViewFrame.origin.x = IAV.SCREEN_WIDTH
                UIView.animate(withDuration: 0.4, animations: {
                    _colorView.frame = _colorViewFrame
                }) { (_finished) in
                    _colorView.removeFromSuperview()
                }
            }
        }
    }
    
    fileprivate func addColorViews(){
        let _space:CGFloat = 10
        let _fDimension = CGFloat(self.dimension)
        let _width:CGFloat = (self.boardView.frame.width - (_space * (_fDimension + 1.0))) / _fDimension
        
        let _size = CGSize(width: _width, height: _width)
        var _orgY = _space
        let _colorIndex = Int.random(in: 0...self.dimension*self.dimension-1)
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
                    _colorIndex == _viewID ?
                    _differentColor : _sourceColor
                UIView.animate(withDuration: 0.4, animations: {
                    _colorView.frame = _colorViewRect
                }) { (_finished) in
                    _colorView.setNeedsDisplay()
                }
                _orgX = _orgX + _width + _space
            }
            _orgY = _orgY + _width + _space
        }
    }
    
//    fileprivate func o
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension OddColorViewController : AnimationDelegate {
    func onAnimationCompleted() {
        debugPrint("game over")
        let _resultView = GameResultView(frame: self.view.bounds)
        _resultView.resultDelegate = self
        _resultView.isHidden = true
        _resultView.coinLabel.text = "\(self.gameManager.coinCounter)"
        _resultView.winsLabel.text = "\(self.gameManager.writeAnserCount)"
        if let _text = _resultView.congratsLabel.text {
            _resultView.congratsLabel.text = _text
                .replacingOccurrences(of: "_",
                                      with: _resultView.winsLabel.text ?? "")
        }
        IAViewAnimation.animate(view: _resultView)
    }
    
    func onAnimationStarted() {
        
    }
    
    func onAnimationStoped() {
        
    }
    
    
}

extension OddColorViewController :GameEndDelegate{
    func dismissSelf() {
        self.navigationController?.popViewController(animated: true)
    }
}


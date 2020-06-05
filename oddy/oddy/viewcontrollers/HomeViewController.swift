//
//  HomeViewController.swift
//  oddy
//
//  Created by Mostafizur Rahman on 8/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    typealias AV = IAViewAnimation
    @IBOutlet var hexagonWidths: [NSLayoutConstraint]!
    @IBOutlet var hexagonHeights: [NSLayoutConstraint]!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet var hexagonButtons: [HexagoanView]!
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let _layer = AV.createParticles(forRect: AV.SCREEN_BOUND)
        self.view.layer.insertSublayer(_layer, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.centerView.layer.cornerRadius = 15
        self.centerView.layer.masksToBounds = true
        self.view.setNeedsDisplay()
        for _view in self.view.subviews {
            _view.layoutIfNeeded()
            _view.updateConstraintsIfNeeded()
            _view.updateFocusIfNeeded()
            _view.setNeedsLayout()
            _view.setNeedsUpdateConstraints()
            _view.setNeedsDisplay()
        }
        
    
        self.performSegue(withIdentifier: "subscribe", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let factor:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.15 : 0.35
        for _height in self.hexagonHeights {
            _height.constant = UIScreen.main.bounds.width * factor
            self.view.layoutIfNeeded()
        }
        for _width in self.hexagonWidths {
            _width.constant = UIScreen.main.bounds.width * factor * 0.9
            self.view.layoutIfNeeded()
            
        }
        
        for _hexagon in self.hexagonButtons {
            _hexagon.setNeedsDisplay()
            _hexagon.setLayers()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for _hexagon in self.hexagonButtons {
            _hexagon.clearAnimation()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

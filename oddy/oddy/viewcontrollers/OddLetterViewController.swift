//
//  OddLetterViewController.swift
//  oddy
//
//  Created by Mostafizur Rahman on 10/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class OddLetterViewController: UIViewController {

    @IBOutlet weak var animationBar:CardAnimationView!
    
//    @IBOutlet var hexagonButtons: [HexagoanView]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    } 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animationBar.configureGradient()
//        for _hexagon in self.hexagonButtons {
//            _hexagon.setNeedsDisplay()
//            _hexagon.setLayers(hasLabelAnimation: false)
//        }
    }
    
    @IBAction func exitGame(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.animationBar.createAnimationGroup()
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

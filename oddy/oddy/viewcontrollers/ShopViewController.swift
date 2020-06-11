//
//  ShopViewController.swift
//  oddy
//
//  Created by Mostafizur Rahman on 11/6/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    @IBOutlet weak var colorBlind: UILabel!
    @IBOutlet weak var oddColor: UILabel!
    @IBOutlet weak var conina: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.conina.text = "\(UserDefaults.standard.integer(forKey: "coins"))"
        self.oddColor.text = "\(FirebaseManager.shared.oddColorCount)"
        self.colorBlind.text = "\(FirebaseManager.shared.colorBlindCount)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func exit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func openAppStore(_ sender: UIButton) {
        guard let _idf = sender.accessibilityIdentifier else {
            return
        }
        if let url = URL(string: "itms-apps://itunes.apple.com/app/\(_idf)"),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
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

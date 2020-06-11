//
//  TermsViewController.swift
//  erica
//
//  Created by Mostafizur Rahman on 1/24/1398 AP.
//  Copyright © 1398 Mostafizur Rahman. All rights reserved.
//

import UIKit
import WebKit
class TermsViewController: UIViewController {

    
    var termsTitle:String?
    var termsFPath:String?
    var termsWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let _frame = CGRect(origin: CGPoint(x: 0, y: 60), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height-60))
        termsWebView = WKWebView(frame: _frame)
        self.view.addSubview(termsWebView)
        self.view.sendSubviewToBack(termsWebView)
        if let _title = self.termsTitle {
            self.title = _title.uppercased()
        }
        guard let path = self.termsFPath else {return}
        
        do {
            let contents =  try String(contentsOfFile: path, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: path)
            self.termsWebView.loadHTMLString(contents as String, baseURL: baseUrl)
        } catch {
            print(error)
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func exit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func close(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else
        {
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    

}




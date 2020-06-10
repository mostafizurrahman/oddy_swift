//
//  BlindInfoViewController.swift
//  EyeVisionTestPuzzle
//
//  Created by Mostafizur Rahman on 6/8/18.
//  Copyright © 2018 image-app. All rights reserved.
//

import UIKit

class ColorBlindInfoViewController: UIViewController {

    private var jsonData: JSON!
    private var isPresented:Bool = false
    @IBOutlet weak var blindInfoTableView: UITableView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let file = Bundle(for:AppDelegate.self).path(forResource: "ColorBlindInfo", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: file))
            jsonData =  JSON(data:data)
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func exitViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension ColorBlindInfoViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return jsonData["color_blind_causea"].count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData["color_blind_causea"][section]["points"].count * 2 + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2 == 0){
            return tableView.dequeueReusableCell(withIdentifier: "EmptyRow")!
        }
        
        let row:Int = Int((indexPath.row - 1) / 2)
//        let section:Int = Int((indexPath.section - 1) / 2)
        if(row == 0){
            if(indexPath.section == jsonData["color_blind_causea"].count - 1){
                let tableRow = tableView.dequeueReusableCell(withIdentifier: "ImageRow", for: indexPath)
                
                return tableRow
            }
            let tableRow = tableView.dequeueReusableCell(withIdentifier: "DataRow", for: indexPath)
            guard let inforRow = tableRow as? InfoTableViewCell else {
                
                return tableRow
            }
            
            
            
            inforRow.dataLabel.text = jsonData["color_blind_causea"][indexPath.section]["subtitle"].stringValue
            
            inforRow.leaadingImageLayout.constant = 25
            inforRow.leadingLabelLayout.constant = 55
            inforRow.widthLayout.constant = 20
            
            inforRow.heightLayout.constant = 20
            inforRow.gredientBulletView.layer.cornerRadius = 10;
            inforRow.gredientBulletView.setStart(color: UIColor.init(rgb: 0xFF0623),
                                                 endColor: UIColor.init(rgb: 0x8556e3))
            return inforRow
            
            
        }
        guard let inforRow = tableView.dequeueReusableCell(withIdentifier: "DataRow", for: indexPath) as? InfoTableViewCell else  {
            let row = tableView.dequeueReusableCell(withIdentifier: "DataRow", for: indexPath)
            return row
        }
        print("section\(indexPath.section) row\(row)")
        inforRow.dataLabel.text = jsonData["color_blind_causea"][indexPath.section]["points"][row].stringValue
        inforRow.leaadingImageLayout.constant = 40
        inforRow.leadingLabelLayout.constant = 70
        inforRow.widthLayout.constant = 15
        inforRow.heightLayout.constant = 15
        inforRow.gredientBulletView.layer.cornerRadius = 7.5;
        inforRow.gredientBulletView.setStart(color: UIColor.init(rgb: 0x7fc0fd),
        endColor: UIColor.init(rgb: 0x9c5eA3))
        return inforRow
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row % 2 == 0){
            return 15
        }
        if(indexPath.section == jsonData["color_blind_causea"].count - 1){
           
            return 420
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if (section % 2 == 0){
//            return tableView.dequeueReusableCell(withIdentifier: "EmptyRow")
//        }
        let header = tableView .dequeueReusableCell(withIdentifier: "HeaderRow") as? InfoTableViewCell
        header?.dataLabel.text = jsonData["color_blind_causea"][section]["title"].stringValue
        return header
    }
    
}

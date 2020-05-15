//
//  LettersViewController.swift
//  EyeVisionTestPuzzle
//
//  Created by Mostafizur Rahman on 6/5/20.
//  Copyright © 2020 image-app. All rights reserved.
//

import UIKit

class LettersViewController: UIViewController {

    @IBOutlet weak var titleLabel: LTMorphingLabel!
    let screenSize = UIScreen.main.bounds.size
    
    var instrucitonView:InstructionView?
    @IBOutlet weak var letterCollectioinView: UICollectionView!
    var letterArray:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCollectionView(forWidth:Int(screenSize.width))
        self.readEmojiArray()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleLabel.morphingEffect = LTMorphingEffect.evaporate
        titleLabel.text = "Pick A Character"
        titleLabel.updateProgress(progress: 0.0)
        titleLabel.start()
    }
    
    @IBAction func closLetterViewControlelr(_ sender: IALinearButton) {
        if let _nav = self.navigationController {
            _nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    
    }
    
    fileprivate func readEmojiArray(){
        if let _path = Bundle.main.path(forResource: "ImageEmog", ofType: "json"){
            do {
                let _string = try NSString.init(contentsOfFile: _path,
                                                encoding: String.Encoding.utf8.rawValue)
                let _array = _string
                    .trimmingCharacters(in: CharacterSet.newlines)
                    .trimmingCharacters(in: .whitespaces)
                    .replacingOccurrences(of: " ", with: "")
                    .map { String($0)}
                self.letterArray = _array
                self.letterCollectioinView.reloadData()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let _idf = segue.identifier {
            if _idf.elementsEqual("start_game") {
                if let _dest = segue.destination as? OddLetterViewController {

                    _dest.sourceLetter = sender as! [String]
                    _dest.letterArray = self.letterArray
                }
            }
        }
        
        
    }
    func configureCollectionView(forWidth _width:Int){
        let count = _width > 700 ? 8 : 4
        let space = (count + 1 ) * 24
        let dimension = (_width - space) / count
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: dimension, height: dimension)
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        self.letterCollectioinView.collectionViewLayout.invalidateLayout()
        self.letterCollectioinView.collectionViewLayout = layout
    }
}


extension LettersViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emoji", for: indexPath)
        if let _label = _cell.contentView.viewWithTag(1234) as? UILabel {
            _label.text = self.letterArray[indexPath.row]
        }
        if let _shadow = _cell.contentView.viewWithTag(1111) as? ShadowView {
            _shadow.shadowColor = UIColor.black
        }
        return _cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.letterArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if UserDefaults.standard.bool(forKey: "never_ask") {
            var _data:[String] = []
            if  indexPath.row == 0 ||
                indexPath.row == 1 ||
                indexPath.row == 2{
                for i in indexPath.row+3...indexPath.row+5{
                    _data.append(self.letterArray[i])
                }
            } else if indexPath.row == self.letterArray.count - 1 ||
                indexPath.row == self.letterArray.count - 2 ||
                indexPath.row == self.letterArray.count - 3 {
                for i in self.letterArray.count -
                    6...self.letterArray.count - 4 {
                    _data.append(self.letterArray[i])
                }
            } else {
                _data.append(self.letterArray[indexPath.row+1])
                _data.append(self.letterArray[indexPath.row+2])
                _data.append(self.letterArray[indexPath.row-1])
            }
            _data.append(self.letterArray[indexPath.row])
            self.performSegue(withIdentifier: "start_game", sender: _data)
        } else {
            self.openInstructions(indexPath: indexPath)
        }
    }
    
    fileprivate func openInstructions(indexPath:IndexPath){
        
        self.instrucitonView = InstructionView(frame: UIScreen.main.bounds)
        self.instrucitonView?.instructionDelegate = self
        guard let _instruction = self.instrucitonView else {return}
        _instruction.selectedLabel.text = self.letterArray[indexPath.row]
        if indexPath.row == 0 ||
            indexPath.row == 1 ||
            indexPath.row == 2{
            _instruction.sampleLables[0].text =  self.letterArray[indexPath.row+1]
            _instruction.sampleLables[1].text =  self.letterArray[indexPath.row+2]
            _instruction.sampleLables[2].text =  self.letterArray[indexPath.row+3]
        } else if indexPath.row == self.letterArray.count - 1 ||
             indexPath.row == self.letterArray.count - 2 ||
             indexPath.row == self.letterArray.count - 3 {
            _instruction.sampleLables[0].text = self.letterArray[self.letterArray.count - 4]
            _instruction.sampleLables[1].text = self.letterArray[self.letterArray.count  - 5]
            _instruction.sampleLables[2].text = self.letterArray[self.letterArray.count - 6]
        } else {
            _instruction.sampleLables[0].text = self.letterArray[indexPath.row + 1]
            _instruction.sampleLables[1].text = self.letterArray[indexPath.row + 2]
            _instruction.sampleLables[2].text = self.letterArray[indexPath.row - 1]
        }
        _instruction.instructionLabel.text = _instruction.instructionLabel
            .text?.replacingOccurrences(of: "_", with: _instruction.selectedLabel.text ?? "")
        _instruction.isHidden = true
        self.view.addSubview(_instruction)
        _instruction.setShadows()
        IAViewAnimation.animate(view: _instruction)
    }
}

extension LettersViewController:SelectionDelegate{
    
    
    func onDoneTap(shouldPlay:Bool) {
        guard let _inst = self.instrucitonView else {return}
        _inst.layer.cornerRadius = 35
        _inst.layer.masksToBounds = true
        _inst.instructionDelegate = nil
        var _tough = [String]()
        if let _text = self.instrucitonView?.selectedLabel.text {
            if let _index = self.letterArray.firstIndex(of: _text) {
                let startIndex = _index < 5 ? 0 :
                    (_index > self.letterArray.count - 5 ?
                    self.letterArray.count - 11 : _index - 5)
                for i in startIndex...startIndex + 10 {
                    let _data = self.letterArray[i]
                    if !_data.elementsEqual(_text) {
                        _tough.append(_data)
                    }
                }
            }
            _tough.append(_text)
        }
        IAViewAnimation.animate(view: _inst, shouldVisible: false) { (_finished) in
            _inst.removeFromSuperview()
            if shouldPlay{
                self.performSegue(withIdentifier: "start_game", sender: _tough)
            }
        }
    }
    
    
}

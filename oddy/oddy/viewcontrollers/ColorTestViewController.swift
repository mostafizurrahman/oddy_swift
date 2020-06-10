//
//  ColorBlindViewController.swift
//  Puzzle Eye Vision Power Test
//
//  Created by Mostafizur Rahman on 6/6/18.
//  Copyright © 2018 image-app. All rights reserved.
//

import UIKit

extension ColorTestViewController:AnswerSelectionDelegate{

    func didSelectAnswer(isRight:Bool){
        if isRight {
            self.gameManager.writeAnserCount += 1
            self.gameManager.coinCounter += 1
        }
        let userAnswer = TestAnswer.init(imageNamed: currentData["data_image_name"] as! String,
                                         testIds: currentData["test_data_id"] as! String,
                                         rightAnswer:isRight)
        self.userAnswers.append(userAnswer)

        self.scrollToNext()
    }
}

class ColorTestViewController: UIViewController {

    typealias FM = FirebaseManager
    typealias GM = GameManager
    
    @IBOutlet weak var imageHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var colorContainer:IARadialButton!
    @IBOutlet weak var numberView: NumberView!
    @IBOutlet weak var animationView:CardAnimationView!
    
    
    
    let gameManager = GM.shared
    let centeredLayout = IACenterFlowLayout()
    var testCompleted:Bool = false
    var currentData:[String:AnyObject] = [String:AnyObject]()
    var userAnswers:[TestAnswer] = [TestAnswer]()
    
    var arrayIndex:[Int] = [Int]()
    
    
    var colorDimensio:CGFloat = 0.0
    
    private var jsonDataSource = JSON()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let file = Bundle(for:AppDelegate.self).path(forResource: "BlindTest", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: file)) {
                jsonDataSource = JSON(data:data)
            }
            var array:[Int] = [Int]()
            for i in 0...jsonDataSource["blind_test_data"].count - 1{
                array.append(i)
            }
            arrayIndex = array.shuffle
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func exitViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if FM.shared.colorBlindCount  > 0 {
            FM.shared.colorBlindCount -= 1
            FM.shared.update(gameName: FM.G_BLIND,
                             count: FM.shared.colorBlindCount)
        }
        self.gameManager.gameTitle = "Color Blind"
        self.imageHeightLayout.constant = IAViewAnimation.SCREEN_WIDTH
            - self.colorContainer.frame.origin.x * 2
        self.view.layoutIfNeeded()
        self.colorCollectionView.layoutIfNeeded()
        self.colorCollectionView.setNeedsLayout()
//        self.bottomView.setNeedsDisplay()
        let spacing:CGFloat = 16
        
        self.centeredLayout.sectionInset = UIEdgeInsets(top: spacing,
                                                   left: spacing+2,
                                                   bottom: spacing,
                                                   right: spacing)
        self.colorDimensio = self.colorCollectionView.frame.width - 2 * spacing - 5
        
        self.colorContainer.cornerRadius = self.imageHeightLayout.constant / 2
        self.centeredLayout.minimumInteritemSpacing = spacing * 2
        self.centeredLayout.minimumLineSpacing = spacing * 2
        
        self.centeredLayout.itemSize = CGSize(width:self.colorDimensio,
                                              height:self.colorDimensio)
        self.centeredLayout.scrollDirection = .horizontal

        self.colorCollectionView.collectionViewLayout = self.centeredLayout
        self.colorCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        let count = String(jsonDataSource["blind_test_data"].count)
        self.answerLabel.text = "1/" + count
        self.numberView.answerDelegate = self

        self.setDataAt(cellIndex: 0)
        //        self.scrollViewDidEndDecelerating(self.colorCollectionView)
    }
 

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if testCompleted {
            return
        }
        self.numberView.setNeedsDisplay()
        if self.animationView.animationDelegate == nil {
            self.animationView.configureGradient(delegate: self)
            self.animationView.startAnimation(withDuration: 30)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.colorCollectionView.reloadData()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier else {
            return
        }
        if identifier.elementsEqual("ScoreSegue") {
//            guard let destination = segue.destination as? ScoreViewController else {
//                return
//            }
//            destination.answerList = self.userAnswers
        }
    }
    

    func setDataAt(cellIndex index:NSInteger){
        guard let data = jsonDataSource["blind_test_data"][arrayIndex[index]].dictionaryObject as [String:AnyObject]? else {
            return
        }
        currentData = data
        guard let answerArray = data["possible_values"] as? [String],
            let rightAns = data["right_answer"] as? String else {
                return
        }
        self.numberView.setAnsers(data: answerArray, rightAnswer: rightAns)
    }
    

    

    
    deinit {
        
        self.animationView.removeAnimations()
    }

    
    
    fileprivate func scrollToNext() {
        let visibleCells = self.colorCollectionView.visibleCells
        guard let dataCell = visibleCells.first as? ColorCollectionViewCell else {
            return
        }
        guard let indexPath = self.colorCollectionView.indexPath(for: dataCell) else {
            return
        }
        let index = indexPath.row
        if index == jsonDataSource["blind_test_data"].count - 1 {
            print("end test")
//            self.animationView.stopAnimation()
            var incompleteCount = 0
            var rightCount = 0
            var wrongCount = 0
            for  answer in  self.userAnswers{
                if answer.isTimeout {
                    incompleteCount += 1
                    wrongCount += 1
                } else if answer.right {
                    rightCount += 1
                } else {
                    wrongCount += 1
                }
            }
            self.testCompleted = true
            self.openGameOverDialog()
//            self.incompleteAnswerCountLabel.text = String(format:"Incompleted answers : %lu",incompleteCount)
//            self.correctAnswerCountLabel.text = String(format:"Right answers : %lu", rightCount)
//            self.wrongAnswerCountLabel.text = String(format:"Wrong answers : %lu", wrongCount)
//            let percentage:Double = Double(rightCount) / Double(jsonDataSource["blind_test_data"].count)
//            if percentage > 0.85 {
//
//                self.conclusionLabel.text = "You have answered mosth of the test questions correctly. Which leads to strong color reasoning abilities of your eyes. You have better color vision. Thank you!"
//            } else if percentage > 0.65 {
//
//                self.conclusionLabel.text = "Tritan-type color blindness is detected! This may be caused by age-related factors, genetic factors, as well as exposure to certain toxins such as mercury. A complete diagnosis of color vision deficiency is not possible using online testing–consult an eye care professional for more information"
//            } else {
//                self.conclusionLabel.text = "Deutans are people with deuteranomaly, a type of red-green color blindness in which the green cones do not detect enough green and are too sensitive to yellows, oranges, and reds. It is high time to see an eye doctor for better help. Thank you!"
//            }
//            BCInterfaceHelper.animateOpacityViewToVisible(self.finalResultView, anim_completion: { (finish) in
//                self.testCompleted = true
//                self.animationView.stopAnimation()
//            })
        } else {
            let nextIndexPath = IndexPath(row: index + 1, section: 0)
            self.colorCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            self.setDataAt(cellIndex: index + 1)
            self.animationView.startAnimation(withDuration: 15)
            let count = String(jsonDataSource["blind_test_data"].count)
            let current = String(index+2)
            self.answerLabel.text = current+"/"+count
        }
    }
    
    override func onAnimationCompleted() {
        if !self.testCompleted {
            guard let indexPath = self.colorCollectionView.indexPathsForVisibleItems.first else {
                return
            }
            self.testCompleted = indexPath.row == jsonDataSource["blind_test_data"].count - 1
            if self.testCompleted {
                self.openGameOverDialog()
            } else {
                self.scrollToNext()
            }
        }
    }
}



extension ColorTestViewController:UICollectionViewDataSource, UIScrollViewDelegate,
 UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.colorDimensio, height: self.colorDimensio)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonDataSource["blind_test_data"].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell",
                                                 for: indexPath) is ColorCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        }
        let dataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCollectionViewCell
        guard let data = jsonDataSource["blind_test_data"][arrayIndex[indexPath.row]].dictionaryObject as [String:AnyObject]? else {
            return dataCell
        }
        
        dataCell.colorView.setData(data: data, dimension:self.colorDimensio)
        
        if dataCell.colorView.layer.cornerRadius == 0 {
            dataCell.colorView.layer.cornerRadius = self.colorDimensio/2
            dataCell.colorView.layer.masksToBounds = true
        }
        return dataCell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let visibleCells = self.colorCollectionView.visibleCells
        if visibleCells.count == 0 {
            self.setDataAt(cellIndex: 0)
            return
        }
        guard let dataCell = visibleCells.first as? ColorCollectionViewCell else {
            return
        }
        guard let indexPath = self.colorCollectionView.indexPath(for: dataCell) else {
            return
        }
        let index = indexPath.row
        self.setDataAt(cellIndex: index)
        
    }
    
    override func dismissSelf(isPlayAgain:Bool) {
        debugPrint("done!")
        if isPlayAgain {
            self.playAgain()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func playAgain(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        
            self.answerLabel.text = "1/\(self.jsonDataSource["blind_test_data"].count)"
            self.gameManager.coinCounter = 0
            self.gameManager.writeAnserCount = 0
            self.userAnswers.removeAll()
            self.animationView.startAnimation(withDuration: 31)
            self.testCompleted = false
            
            self.colorCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                  at: UICollectionView.ScrollPosition.left,
                                                  animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 00.3) {
                self.colorCollectionView.reloadData()
                self.setDataAt(cellIndex: 0)
            }
        }
    }
    
}

extension Array {
    var shuffle:[Element] {
        var elements = self
        for index in 0..<elements.count {
            let anotherIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
            if anotherIndex != index {
                elements.swapAt(index, anotherIndex)
            }
        }
        return elements
    }
}



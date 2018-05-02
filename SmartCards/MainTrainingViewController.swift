//
//  MainTrainingViewController.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 02/05/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

protocol RandomFuncs {
    func randomInt(max:Int) -> Int
}

enum Mode {
    case global
    case local
}

class MainTrainingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topBarTitle: UINavigationItem!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var translationField: UITextField!
    
    var timer = Timer()
    let multiplier: Int = 3 // determines how many rounds will be in training
    var trainingSets: [SmartSet] = [SmartSet]()
    var mode: Mode = .local
    var score: Int = 0
    var count: Int = 0
    var figure: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translationField.delegate = self
        topBarTitle.title = "Счет: \(score)"
        
        cardLabel.layer.borderWidth = 0.8
        cardLabel.layer.borderColor = UIColor.blue.cgColor
        cardLabel.layer.cornerRadius = 10
        
        switch (mode) {
        case .local:
            count = multiplier * trainingSets[0].words.count
            localGame()
        case .global:
            globalGame()
        }
        
    }
    
    func localGame() {
//      Preparation
        if count == 0 {
            dismiss(animated: true, completion: nil)
        }
        let set = trainingSets[0]
        
        figure = randomInt(max: set.words.count - 1)
        cardLabel.text = set.words[figure].front
        count -= 1
    }
    
    func globalGame() {
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func update() {
        // sth
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let input = textField.text
        
        switch(mode) {
        case .local:
            let set = trainingSets[0]
            if input == set.words[figure].back {
                cardLabel.text = set.words[figure].back
                UIView.animate(withDuration: 0.25, animations: {
                    self.cardLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    self.cardLabel.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
                })
                
                timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
                score += 1
                topBarTitle.title = "Счет: \(score)"
                cardLabel.text = nil
                textField.text = nil
                localGame()
            }
        case .global:
            print("global")
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension MainTrainingViewController: RandomFuncs {
    func randomInt(max:Int) -> Int {
        return Int(arc4random_uniform(UInt32(max + 1)))
    }
}

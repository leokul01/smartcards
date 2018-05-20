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
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var minusLabel: UILabel!
    
    var tmp: Int = 0
    let x = 19.934 //Experimental constant
    var multiplier: Int = 2 // determines how many rounds will be in training. Defines in settings of this program
    
    var trainingSets: [SmartSet] = [SmartSet]()
    var setsNumberForTraining: Int = 0
    var mode: Mode = .local
    var score: Int = 0
    var count: Int = 0
    var figure: Int = 0
    var path: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating path for train
        self.path = makePath()
        self.tmp = multiplier
        multiplier -= 1
        
        for i in 0..<trainingSets[setsNumberForTraining].words_knowledge.count {
            trainingSets[setsNumberForTraining].words_knowledge[i] = 0
        }
        
        plusLabel.isHidden = true
        minusLabel.isHidden = true
        translationField.delegate = self
        topBarTitle.title = "Счет: \(score)"
        
        cardLabel.layer.borderWidth = 0.8
        cardLabel.layer.borderColor = UIColor.blue.cgColor
        cardLabel.layer.cornerRadius = 10
        
        switch (mode) {
        case .local:
            count = trainingSets[setsNumberForTraining].words_front.count
            localGame()
        case .global:
            globalGame()
        }
        
    }
    
    func localGame() {
        if count == 0 && multiplier == 0 {
            totals()
            return
        } else if count == 0 {
            self.path = makePath()
            multiplier -= 1
            count = trainingSets[setsNumberForTraining].words_front.count
        }
        
        figure = self.path[count - 1]
        cardLabel.text = trainingSets[setsNumberForTraining].words_front[figure]
        count -= 1
    }
    
    func globalGame() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let input = textField.text
        
        switch(mode) {
        case .local:
            let set = trainingSets[setsNumberForTraining]
            let didInputCorrect = input == set.words_back[figure]
            if didInputCorrect {
                UIView.animate(withDuration: 0.25, animations: {
                    self.cardLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    self.cardLabel.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
                })
                cardLabel.text = set.words_back[figure]
                plusLabel.isHidden = false
                
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.cardLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    self.cardLabel.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
                })
                cardLabel.text = set.words_back[figure]
                minusLabel.isHidden = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if didInputCorrect {
                    self.trainingSets[self.setsNumberForTraining].words_knowledge[self.figure] += 1
                    self.plusLabel.isHidden = true
                    self.score += 1
                } else {
                    self.minusLabel.isHidden = true
                    self.score -= 1
                }
                
                self.topBarTitle.title = "Счет: \(self.score)"
                textField.text = nil
                self.localGame()
            }
            
        case .global:
            print("global")
        }
        textField.resignFirstResponder()
        return true
    }
    
    func totals() {
        //recalculating words_knowledge
        multiplier = tmp
        var sumOfWordKnowledges: Double = 0
        for i in 0..<trainingSets[setsNumberForTraining].words_front.count {
            trainingSets[setsNumberForTraining].words_knowledge[i] = trainingSets[setsNumberForTraining].words_knowledge[i] / Double(multiplier)
            sumOfWordKnowledges += trainingSets[setsNumberForTraining].words_knowledge[i]
        }
        
        //recalc knowledge of set
        let knowledge = trainingSets[setsNumberForTraining].knowledge + (sumOfWordKnowledges / Double(trainingSets[setsNumberForTraining].words_front.count)) * x
        dataManager.changeKnowledge(at: setsNumberForTraining, newValue: knowledge)
        
        //and time
        dataManager.changeTimeLastTrainEnd(at: setsNumberForTraining, newValue: getCurrentTimeInHours())
        showWarningAlert(knowledge: sumOfWordKnowledges / Double(trainingSets[setsNumberForTraining].words_front.count))
    }
    
    func getCurrentTimeInHours() -> Double {
        let seconds = NSDate().timeIntervalSince1970 // seconds
        return seconds/3600
    }
    
    func makePath() -> [Int] {
        var path = [Int]()
        var resultSet = Set<Int>()
        while resultSet.count < trainingSets[setsNumberForTraining].words_front.count {
            figure = randomInt(max: trainingSets[setsNumberForTraining].words_front.count - 1)
            if !resultSet.contains(figure) {
                path.append(figure)
            }
            resultSet.insert(figure)
        }
        return path
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let receiverVC = segue.destination as? SetsViewController {
            receiverVC.setsTableView?.reloadData()
        }
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

extension MainTrainingViewController {
    func showWarningAlert(knowledge: Double) {
        let title = NSLocalizedString("Тренировка окончена", comment: "")
        let message = NSLocalizedString("Процент верных ответов: \(100 * knowledge)%", comment: "")
        let exitViewButtonTitle = NSLocalizedString("Гип-гип ураа!", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the action.
        let exitViewAction = UIAlertAction(title: exitViewButtonTitle, style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        // Add the action.
        alertController.addAction(exitViewAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

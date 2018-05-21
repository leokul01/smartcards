//
//  SetsCardsViewController.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 29/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

protocol SetsCardsViewControllerAlerts {
    func showWarningAlert(_ header: String, _ subHeader: String)
}

class SetsCardsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardNumber: UINavigationItem!
    @IBOutlet weak var promtLabel: UILabel!
    @IBOutlet weak var addFrontCardText: UITextField!
    @IBOutlet weak var turnCardAround: UIButton!
    @IBOutlet weak var deleteCardButton: UIBarButtonItem!
    @IBOutlet weak var readyButton: UIButton!
    
    var name: String = ""
    var cover: UIImage = UIImage(named: "unknown")!
    var about: String = ""
    var lastModifiedItem: Int = 0
    
    var frontCard: String = ""
    var backCard: String = ""
    var didCardTurn = false
    
    var iterator = 0
    var cardsCollection: [(knowledge: Double, front: String, back: String)] = [(knowledge: 0.0, front: "", back: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        deleteCardButton.isEnabled = false
        turnCardAround.setTitle("->", for: UIControlState.normal)
        cardNumber.title = "Карточка № \(iterator)"
        addFrontCardText.layer.borderWidth = 0.8
        addFrontCardText.layer.borderColor = UIColor.blue.cgColor
        addFrontCardText.layer.cornerRadius = 10
        
        readyButton.layer.borderWidth = 0.8
        readyButton.layer.borderColor = UIColor.blue.cgColor
        readyButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteCurrentCard(_ sender: Any) {
        cardsCollection.remove(at: lastModifiedItem)
        frontCard = cardsCollection[lastModifiedItem].front
        backCard = cardsCollection[lastModifiedItem].back
        addFrontCardText.text = frontCard
        promtLabel.text = "Введите изучаемое слово"
        cardNumber.title = "Карточка № \(lastModifiedItem)"
        turnCardAround.setTitle("->", for: UIControlState.normal)
        didCardTurn = false
        
        iterator = 0
        collectionView.reloadData()
    }
    @IBAction func turnAroundAction(_ sender: Any) {
        if (!didCardTurn) {
            promtLabel.text = "Введите перевод"
            UIView.animate(withDuration: 0.25, animations: {
                self.addFrontCardText.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.addFrontCardText.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
            })
            frontCard = addFrontCardText.text ?? ""
            addFrontCardText.text = backCard
            turnCardAround.setTitle("<-", for: UIControlState.normal)
            didCardTurn = true
        } else {
            promtLabel.text = "Введите изучаемое слово"
            UIView.animate(withDuration: 0.25, animations: {
                self.addFrontCardText.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.addFrontCardText.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
            })
            backCard = addFrontCardText.text ?? ""
            addFrontCardText.text = frontCard
            turnCardAround.setTitle("->", for: UIControlState.normal)
            didCardTurn = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! SetsViewController
        
        if cardsCollection[cardsCollection.count - 1].back == "" || cardsCollection[cardsCollection.count - 1].front == "" {
            if lastModifiedItem == cardsCollection.count - 1 && frontCard != "" {
                if backCard == "" && didCardTurn {
                    backCard = addFrontCardText.text ?? ""
                }
                cardsCollection[cardsCollection.count - 1] = (knowledge: 0, front: frontCard, back: backCard)
            } else {
                if cardsCollection.count == 1 {
                    showWarningAlert("Набор без карточек!", "Создать набор - это хорошо, но добавить в него еще и карточки - идеально.")
                    return
                } else {
                    cardsCollection.remove(at: cardsCollection.count - 1)
                }
            }
            
        }
        let timetmp: Double = NSDate().timeIntervalSince1970 / 3600
        globalTime = timetmp
        dataManager.addSet(name: name, cover: cover, about: about, knowledge: 0.000000000001, timeLastTrainEnd: timetmp)

        var tmp_knowledge = [Double]()
        var tmp_front = [String]()
        var tmp_back = [String]()
        for i in 0..<cardsCollection.count {
            tmp_knowledge.append(cardsCollection[i].knowledge)
            tmp_front.append(cardsCollection[i].front)
            tmp_back.append(cardsCollection[i].back)
        }
        dataManager.addCards(at: dataManager.sets.count - 1, words_knowledge: tmp_knowledge, words_front: tmp_front, words_back: tmp_back)
        receiverVC.setsTableView?.reloadData()
    }

}

extension SetsCardsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return cardsCollection.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (iterator < cardsCollection.count && indexPath.section == 0) {
        case true:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CollectionViewCell
            
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            
            cell.cardNumber.text = String(self.iterator)
            iterator += 1
            return cell
        case false:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath as IndexPath) as! AddCollectionViewCell
            
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            
            cell.addCardLabel.text = "+"
            cell.addCardLabel.textColor = UIColor.blue
            return cell
        }
    }

}

extension SetsCardsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didCardTurn {backCard = addFrontCardText.text ?? ""}
        else {frontCard = addFrontCardText.text ?? ""}
        if indexPath.section == 1 {
            deleteCardButton.isEnabled = false
            if (lastModifiedItem != cardsCollection.count - 1) {
                frontCard = cardsCollection[cardsCollection.count - 1].front
                backCard = cardsCollection[cardsCollection.count - 1].back
            }
            if frontCard == "" || backCard == "" {
                let header = "Заполните карточку"
                let subheader = "Одно из полей (или оба) не заполнено(-ны)."
                showWarningAlert(header, subheader)
                return
            }
            for i in 0..<cardsCollection.count {
                if frontCard == cardsCollection[i].front && backCard == cardsCollection[i].back {
                    let header = "Полное совпадение"
                    let subheader = "Вы уже ввели такую карточку. В этот раз без штрафа, но впредь будьте осторожнее!"
                    showWarningAlert(header,subheader)
                    frontCard = ""
                    backCard = ""
                    addFrontCardText.text = nil
                    promtLabel.text = "Введите изучаемое слово"
                    UIView.animate(withDuration: 0.25, animations: {
                        self.addFrontCardText.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                        self.addFrontCardText.transform = CGAffineTransform(rotationAngle: 2 * CGFloat.pi)
                    })
                    turnCardAround.setTitle("->", for: UIControlState.normal)
                    didCardTurn = false
                    return
                }
            }
            cardsCollection[cardsCollection.count - 1] = (knowledge: 0, front: frontCard, back: backCard)
            cardsCollection.append((knowledge: 0, front: "", back: ""))
            frontCard = ""
            backCard = ""
            addFrontCardText?.text = nil
            lastModifiedItem = cardsCollection.count - 1
            cardNumber.title = "Карточка № \(lastModifiedItem)"
        } else {
            cardsCollection[lastModifiedItem] = (knowledge: 0, front: frontCard, back: backCard)
            lastModifiedItem = indexPath.item
            frontCard = cardsCollection[indexPath.item].front
            backCard = cardsCollection[indexPath.item].back
            addFrontCardText.text = frontCard
            if (indexPath.item != cardsCollection.count - 1) {deleteCardButton.isEnabled = true} else {deleteCardButton.isEnabled = false}
            cardNumber.title = "Карточка № \(indexPath.item)"
        }
        promtLabel.text = "Введите изучаемое слово"
        turnCardAround.setTitle("->", for: UIControlState.normal)
        didCardTurn = false
        iterator = 0
        collectionView.reloadData()
    }
}

extension SetsCardsViewController: SetsCardsViewControllerAlerts {
    func showWarningAlert(_ header: String, _ subHeader: String) {
        let title = NSLocalizedString(header, comment: "")
        let message = NSLocalizedString(subHeader, comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}





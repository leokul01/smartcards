//
//  SetsCardsViewController.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 29/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

class SetsCardsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardNumber: UINavigationItem!
    @IBOutlet weak var promtLabel: UILabel!
    @IBOutlet weak var addFrontCardText: UITextField!
    @IBOutlet weak var turnCardAround: UIButton!
    
    var bufFCard: String = ""
    var bufBCard: String = ""
    var state = false
    
    var frontCard: String = ""
    var backCard: String = ""
    var didCardTurn = false
    
    var iterator = 0
    var cardsCollection: [String:String] = ["":""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        turnCardAround.setTitle("->", for: UIControlState.normal)
        cardNumber.title = "Карточка № \(iterator)"
        addFrontCardText.layer.borderWidth = 0.8
        addFrontCardText.layer.borderColor = UIColor.blue.cgColor
        addFrontCardText.layer.cornerRadius = 10
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
    
//    @objc func DismissKeyboard(){
//        //Causes the view to resign from the status of first responder.
//        view.endEditing(true)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SetsCardsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsCollection.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (iterator < cardsCollection.count) {
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
            
            cell.layer.borderColor = UIColor.lightGray.cgColor
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
        if didCardTurn, backCard == "" {backCard = addFrontCardText.text ?? ""}
        if indexPath.item == cardsCollection.count/*, frontCard != "", backCard != ""*/ { // last item
            cardsCollection[frontCard] = backCard
            frontCard = ""
            backCard = ""
            addFrontCardText?.text = nil
            cardNumber.title = "Карточка № \(cardsCollection.count - 1)"
        } else if indexPath.item != (cardsCollection.count - 1) { // other except last and prelast
            if bufFCard == "", !state {
                state = true
                bufFCard = frontCard
                bufBCard = backCard
            }
            frontCard = Array(cardsCollection)[indexPath.item + 1].key
            backCard = Array(cardsCollection)[indexPath.item + 1].value
            promtLabel.text = "Введите изучаемое слово"
            cardNumber.title = "Карточка № \(indexPath.item)"
            addFrontCardText.text = frontCard
        } else { // prelast
            frontCard = bufFCard
            backCard = bufBCard
            bufFCard = ""
            bufBCard = ""
            state = false
            addFrontCardText?.text = frontCard
            cardNumber.title = "Карточка № \(cardsCollection.count - 1)"
        }
        turnCardAround.setTitle("->", for: UIControlState.normal)
        didCardTurn = false
        iterator = 0
        collectionView.reloadData()
    }
}





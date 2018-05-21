//
//  FirstViewController.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 16/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

let dataManager = DataManager()
var globalTime: Double = NSDate().timeIntervalSince1970 / 3600
var notif: Bool = false

class SetsViewController: UIViewController{

    @IBOutlet weak var setsTableView: UITableView!
    
    var setsNumberForTraining: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalTime = NSDate().timeIntervalSince1970 / 3600
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if notif {
            setsTableView?.reloadData()
            notif = false
        }
    }
    
    @IBAction func unwindFromAdding(unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let receiverVC = segue.destination as? MainTrainingViewController {
            receiverVC.trainingSets = dataManager.sets
            receiverVC.onDoneBlock = {
                self.setsTableView?.reloadData()
                receiverVC.dismiss(animated: true, completion: nil)
            }
            
            let setsTrainNum = setsTableView.indexPathForSelectedRow?.item
            if let setsTrainNumExplicit = setsTrainNum {
                receiverVC.setsNumberForTraining = setsTrainNumExplicit
            }
        }
    }
}

extension SetsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return dataManager.sets.count
        case 1: return 1
        default:
            print("error")
            exit(1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetsCell", for: indexPath) as! SetsTableViewCell
            cell.setsNameLabel.text = dataManager.sets[indexPath.item].name
            cell.setsDescriptionLabel.text = dataManager.sets[indexPath.item].about
            cell.setsImageView.image = dataManager.sets[indexPath.item].cover
            
            var dt = globalTime - dataManager.sets[indexPath.item].timeLastTrainEnd
            
            // KOSTYL
            if dt == 0 && dataManager.sets[indexPath.item].knowledge == 0.000000000001 {
                dt = 10000000000000
            }
            
            cell.updateProgress(dtime: dt, currentKnowledge: dataManager.sets[indexPath.item].knowledge)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSetCell", for: indexPath) as! AddSetTableViewCell
            return cell
        default:
            print("error")
            exit(1)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            dataManager.removeSet(index: indexPath.row)
            self.setsTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
}

extension SetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

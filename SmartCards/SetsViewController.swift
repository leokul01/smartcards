//
//  FirstViewController.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 16/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

let dataManager = DataManager()

class SetsViewController: UIViewController{

    @IBOutlet weak var setsTableView: UITableView!
    
    var setsNumberForTraining: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindFromAdding(unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let receiverVC = segue.destination as? MainTrainingViewController {
            receiverVC.trainingSets = dataManager.sets
            
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

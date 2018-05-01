//
//  FirstViewController.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 16/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

class SetsViewController: UIViewController{

    @IBOutlet weak var setsTableView: UITableView!
    var sets: [SmartSet] = [SmartSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setsTableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setsTableView.reloadData()
//        if sets.count == 1 {
//            print(sets[0].name, sets[0].description)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromAdding(unwindSegue: UIStoryboardSegue) {
    }
}

extension SetsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return sets.count
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
            cell.setsNameLabel.text = sets[indexPath.item].name
            cell.setsDescriptionLabel.text = sets[indexPath.item].description
            cell.setsImageView.image = sets[indexPath.item].cover
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSetCell", for: indexPath) as! AddSetTableViewCell
            return cell
        default:
            print("error")
            exit(1)
        }
    }
}

extension SetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Pushed string #\(indexPath.row) in section #\(indexPath.section)")
    }
}

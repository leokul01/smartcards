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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setsTableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SetsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetsCell", for: indexPath) as! SetsTableViewCell
        //cell.textLabel?.text = "Hello its me!"
        cell.setsNameLabel?.text = "Hello its me!"
        return cell
    }
}

extension SetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Pushed string #\(indexPath.row) in section #\(indexPath.section)")
    }
}

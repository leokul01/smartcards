//
//  AddSetViewController.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 21/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

class AddSetViewController: UIViewController {
    @IBOutlet weak var addPhotoSet: UIButton!
    @IBOutlet weak var nameSetButton: UIButton!
    @IBOutlet weak var decriptionSetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPhotoSet.layer.borderWidth = 0.8
        addPhotoSet.layer.borderColor = UIColor.blue.cgColor
        addPhotoSet.layer.cornerRadius = 10
        
        //nameSetButton.layer.bo

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromAddingName(unwindSegue: UIStoryboardSegue) {
    }

}

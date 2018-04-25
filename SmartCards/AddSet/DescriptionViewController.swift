//
//  DescriptionViewController.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 22/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

//protocol AddDescriptionViewControllerDelegate {
//    func addDescriptionViewController(_ addDescriptionViewController: DescriptionViewController, didAddDescription description: String)
//}

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
//    var delegate: AddDescriptionViewControllerDelegate?
//    var newDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        //newDescription = descriptionTextView.text ?? ""
        //delegate?.addDescriptionViewController(self, didAddDescription: newDescription)
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! AddSetViewController
        receiverVC.set.description = descriptionTextView.text ?? ""
    }
}

extension DescriptionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
}

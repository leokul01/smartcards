//
//  AddSetViewController.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 21/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

protocol AddCoverNameForSet {
    func nameInputField()
    func photoInputField()
}

class AddSetViewController: UIViewController{
    
    @IBOutlet weak var addPhotoSetButton: UIButton!
    @IBOutlet weak var nameSetButton: UIButton!
    @IBOutlet weak var descriptionSetButton: UIButton!
    
    var set = SmartSet()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addPhotoSetButton.layer.borderWidth = 0.8
        addPhotoSetButton.layer.borderColor = UIColor.blue.cgColor
        addPhotoSetButton.layer.cornerRadius = 10
    }
    
    @IBAction func unwindFromDescriptionViewControllerSave(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func getSetsNameAction(_ sender: Any) {
        nameInputField()
    }
    @IBAction func getPhotoSetAction(_ sender: Any) {
        photoInputField()
    }
    
}

extension AddSetViewController: AddCoverNameForSet {
    func nameInputField() {
        let title = NSLocalizedString("Название сета", comment: "")
        let message = NSLocalizedString("Придумайте короткое и информативное название", comment: "")
        let cancelButtonTitle = NSLocalizedString("Назад", comment: "")
        let saveButtonTitle = NSLocalizedString("Сохранить", comment: "")
        var setName: UITextField?
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add the text field for text entry.
        alertController.addTextField { (textField) -> Void in
            setName = textField
            setName?.placeholder = "Введите название сета..."
        }
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
            print("The \"Text Entry\" alert's cancel action occured.")
        }
        
        let saveAction = UIAlertAction(title: saveButtonTitle, style: .default) { _ in
            print("\(setName?.text ?? "defaultName")")
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func photoInputField() {
        let message = NSLocalizedString("Выберите подходящий вариант добавления фото.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Назад", comment: "")
        let mediaButtonTitle = NSLocalizedString("Выбрать из медиатеки", comment: "")
        let webButtonTitle = NSLocalizedString("Найти в интернете", comment: "")
        let takeShotButtonTitle = NSLocalizedString("Сделать фото", comment: "")
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
            print("The \"OK/Cancel\" alert action sheet's cancel action occured.")
        }
        
        let mediaAction = UIAlertAction(title: mediaButtonTitle, style: .default) { _ in
            print("The \"Confirm\" alert action sheet's destructive action occured.")
        }
        
        let webAction = UIAlertAction(title: webButtonTitle, style: .default) { _ in
            print("The \"Confirm\" alert action sheet's destructive action occured.")
        }
        
        let takeShotAction = UIAlertAction(title: takeShotButtonTitle, style: .default) { _ in
            print("The \"Confirm\" alert action sheet's destructive action occured.")
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(mediaAction)
        alertController.addAction(webAction)
        alertController.addAction(takeShotAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

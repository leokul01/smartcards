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
    
    var name: String = ""
    var cover: UIImage = UIImage(named: "unknown")!
    var about: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPhotoSetButton.layer.borderWidth = 0.8
        addPhotoSetButton.layer.borderColor = UIColor.blue.cgColor
        addPhotoSetButton.layer.cornerRadius = 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let receiverVC = segue.destination as? SetsCardsViewController {
            receiverVC.cover = cover
            receiverVC.name = name
            receiverVC.about = about
        }
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

extension AddSetViewController: AddCoverNameForSet, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
            self.name = setName?.text ?? "Безымянный"
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
            let image = UIImagePickerController()
            image.delegate = self
            
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            image.allowsEditing = false
            
            self.present(image, animated: true) {
                // after it is done
            }
            
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.addPhotoSetButton.setTitle("", for: .normal)
            self.addPhotoSetButton.layer.borderWidth = 0
            self.cover = image
            self.addPhotoSetButton.setImage(self.cover, for: .normal)
        } else {
            print("Error in imagePickerController")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

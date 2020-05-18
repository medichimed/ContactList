//
//  EditingPageExtensions.swift
//  task9
//
//  Created by Oksana Kotilevska on 1/9/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

extension EditingPageViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let enteredText = textField.text ?? ""
        let fixedText = enteredText.isEmpty ? nil : enteredText
        
        if textField == textFieldNameFirst {
            passedContact.firstName = fixedText
        }else if textField == textFieldNameSecond{
            passedContact.secondName = fixedText
        }else if textField == textFieldPhone{
            passedContact.phone = fixedText
        }else if textField == textFieldEmail{
            passedContact.email = fixedText
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent? ) {
        textFieldNameFirst.resignFirstResponder()
        textFieldNameSecond.resignFirstResponder()
        textFieldPhone.resignFirstResponder()
        textFieldEmail.resignFirstResponder()
    }
}

extension EditingPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageViewAvatar.image = image
            avatarImage = image
            passedContact.photoHasBeenUpdated = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditingPageViewController{
    
    func setContactDetails(){
        
        imageViewAvatar.image = passedContact.image
        textFieldNameFirst.text = passedContact?.firstName ?? ""
        textFieldNameSecond.text = passedContact?.secondName ?? ""
        textFieldPhone.text = passedContact?.phone ?? ""
        textFieldEmail.text = passedContact?.email ?? ""
    }
    
    func setImagePickerControllerActionSheet(){
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let optionMenu = UIAlertController(title: nil , message: "Select image source", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraSource = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (action) in
                imagePickerController.sourceType = .camera
                self?.present(imagePickerController, animated: true, completion: nil)
            })
            optionMenu.addAction(cameraSource)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let gallerySource = UIAlertAction(title: "Gallery", style: .default) { [weak self] (action) in
                imagePickerController.sourceType = .photoLibrary
                self?.present(imagePickerController, animated: true, completion: nil)
            }
            optionMenu.addAction(gallerySource)
        }
        
        let cancelAction = UIAlertAction(title: Title.cancel, style: .default, handler: nil)
        
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func setFunctionalityForNavigationBar(){
        self.navigationItem.rightBarButtonItem?.title = passedContact.contactId == nil ? Title.add : Title.save
        self.navigationItem.rightBarButtonItem?.action = #selector(addTapped)
        self.navigationItem.rightBarButtonItem?.target = self
        
        self.navigationItem.title = passedContact.contactId == nil ? Title.new : passedContact.displayName
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Title.cancel, style: .plain, target: self, action: #selector(dissmissEditPage))
        buttonDelete.isHidden = passedContact.isNew
    }
    
    
    func showAlertMessage(message: String){
        
        let alertMessage = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alertMessage, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertMessage.dismiss(animated: true, completion: nil)
            }
        })
    }
}

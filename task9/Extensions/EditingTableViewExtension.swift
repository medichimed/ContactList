//
//  EditingTableViewExtension.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/5/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//
import UIKit

extension EditPageTableViewController: UITextFieldDelegate{
    
//MARK: - Set NavigationBar
   func setFunctionalityForNavigationBar(){
    self.navigationItem.rightBarButtonItem?.title = passedContact.contactId == nil ? Title.add : Title.save
       self.navigationItem.rightBarButtonItem?.action = #selector(addTapped)
       self.navigationItem.rightBarButtonItem?.target = self
       
    self.navigationItem.title = passedContact.contactId == nil ? Title.new : passedContact.displayName
       
       self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Title.cancel, style: .plain, target: self, action: #selector(dissmissEditPage))
   }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let enteredText = textField.text ?? ""
        let fixedText = enteredText.isEmpty ? nil : enteredText
        
        switch currentCell{
        case .firstName:
            passedContact.firstName = fixedText
        case .lastName:
            passedContact.secondName = fixedText
        case .phone: passedContact.phone = fixedText
        case .email: passedContact.email = fixedText
        case .birthday: passedContact.birthday = fixedText
        case .height: passedContact.height = fixedText
        case .driverLicense: passedContact.driverLicense = fixedText
        default: break
        }
        
        textField.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent? ) {
        view.endEditing(true)
    }
    
    @objc func addTapped() {
            
            view.endEditing(true)
            
            let validationResult = passedContact.validate()
            
            guard case .valid = validationResult else {
                showAlertMessage(message: validationResult.description!)
                return
            }

            let isNew = passedContact.isNew

            if isNew {
                passedContact.setContactId()
                
                if passedContact.hasAvatar, let avatar = avatarImage{
                    passedContact.saveImage(img: avatar)
                }
                
                let contactDictionary = passedContact.toDictionary
                
                StorageService.addContact(newContact: contactDictionary)

            }
            
            if passedContact.photoHasBeenUpdated == true, let img = avatarImage{
                passedContact.saveImage(img: img)
            }
            
            passedDataDelegate.passContactDetails(newContact: passedContact)
            
            if isNew {
                guard let navigationController = navigationController else { return }
                navigationController.dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    
    @objc func dissmissEditPage(){

        if passedContact.isNew {
            guard let navigationController = navigationController else { return }
            navigationController.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
}

extension EditPageTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
     func setImagePickerControllerActionSheet(){
    
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
    
        let optionMenu = UIAlertController(title: nil , message: Title.selectRequest, preferredStyle: .actionSheet)
    
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let cameraSource = UIAlertAction(title: Title.camera, style: .default, handler: { [weak self] (action) in
                    imagePickerController.sourceType = .camera
                    self?.present(imagePickerController, animated: true, completion: nil)
                })
                optionMenu.addAction(cameraSource)
            }
    
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let gallerySource = UIAlertAction(title: Title.gallery, style: .default) { [weak self] (action) in
                    imagePickerController.sourceType = .photoLibrary
                    self?.present(imagePickerController, animated: true, completion: nil)
                }
                optionMenu.addAction(gallerySource)
            }
    
            let cancelAction = UIAlertAction(title: Title.cancel, style: .default, handler: nil)
    
            optionMenu.addAction(cancelAction)
    
            self.present(optionMenu, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            avatarImage = image
            passedContact.photoHasBeenUpdated = true
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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

extension EditPageTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 3 : 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        heightDigits[component] = row
        
        guard let cell = tableView.visibleCells.filter({ return $0 is EditHeightCell }).first as? EditHeightCell else {
            return
        }
        
        cell.updateHeightTextField(didUpdateWith: countHeight)
    }
    
     func countHeight() -> String{
        var start = 0
        var multiplier = 100
        
        for i in heightDigits{
            start = start + (i * multiplier)
            multiplier = multiplier/10
        }
        return "\(start)"
    }
}

struct Title {
        static let add = NSLocalizedString("add", comment: "Add contact")
        static let save = NSLocalizedString("save", comment: "Save changes")
        static let cancel = NSLocalizedString("cancel", comment: "Cancel")
        static let new = NSLocalizedString("newContact", comment: "Unnamed Contact")
        static let confirmMessage = NSLocalizedString("removalConfirmation", comment: "Removal confirmation")
        static let delete = NSLocalizedString("delete", comment: "Deletion")
        static let camera = NSLocalizedString("camera", comment: "Camera")
        static let gallery = NSLocalizedString("gallery", comment: "Gallery")
        static let selectRequest = NSLocalizedString("imageSourceSelection", comment: "Select image source")
    static let optionsRemove = NSLocalizedString("optionsRemove", comment: "Remove")
    static let optionsChange = NSLocalizedString("optionsChange", comment: "Change")
    static let contactRemovalConfirmation = NSLocalizedString( "contactRemovalConfirmation", comment: "Confirmation")
   }

extension EditPageTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = passedContact.contactId else {
            return 8
        }
        return 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = getIdentifier(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        
        return configureCellContent(for: indexPath, target: cell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        currentCell = CellHandbook(rawValue: indexPath.row)
        guard let current = currentCell else { return }
        
        switch current.rawValue{
        case 1...4:
            guard let cell = tableView.cellForRow(at: indexPath) as? EditNamePhoneEmailCell else { return }
            cell.textField.isUserInteractionEnabled = true
            cell.textField.becomeFirstResponder() 
        case 5:
            guard let cell = tableView.cellForRow(at: indexPath) as? EditBirthdayCell else { return }
            cell.textFieldBirthday.isUserInteractionEnabled = true
            cell.textFieldBirthday.becomeFirstResponder()
        case 6:
            guard let cell = tableView.cellForRow(at: indexPath) as? EditHeightCell else { return }
            cell.textFieldHeight.isUserInteractionEnabled = true
            cell.textFieldHeight.becomeFirstResponder()
        case 7:
            guard let cell = tableView.cellForRow(at: indexPath) as? EditDriverLicenseCell else { return }
            cell.textFieldLicense.isUserInteractionEnabled = true
            cell.textFieldLicense.becomeFirstResponder()
        default: break
        }
    }
    
    //MARK: - Filtering functions
    private func getIdentifier(for indexPath: IndexPath) -> String {
        switch indexPath.row{
        case 0: return "AvatarCell"
        case 1...4: return "NamePhoneEmailCell"
        case 5: return "BirthdayCell"
        case 6: return "HeightCell"
        case 7: return "DriverLisenceCell"
        case 8: return "DeleteButtonCell"
        default: break
        }
        return ""
    }
    
    private func configureCellContent(for indexPath: IndexPath, target cell: UITableViewCell) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let configuredCell = cell as! EditAvatarCell

            configureImage(for: configuredCell)
            return configuredCell
        case 1...4:
            let configuredCell =  cell as! EditNamePhoneEmailCell
            
            configuredCell.textField.delegate = self
            
            switch indexPath.row{
            case 1: configureNamePhoneEmailCells(for: configuredCell, with: .firstName)
            case 2: configureNamePhoneEmailCells(for: configuredCell, with: .secondName)
            case 3: configureNamePhoneEmailCells(for: configuredCell, with: .phone)
            case 4: configureNamePhoneEmailCells(for: configuredCell, with: .email)
            default: break
            }
            return configuredCell
        case 5:
            let configuredCell =  cell as! EditBirthdayCell
            configuredCell.textFieldBirthday.delegate = self
            
            configureBirthday(for: configuredCell, with: .birthday)
            
            return configuredCell
        case 6:
            let configuredCell =  cell as! EditHeightCell
            configureHeight(for: configuredCell, with: .height)
            configuredCell.textFieldHeight.delegate = self
            return configuredCell
        case 7:
            let configuredCell =  cell as! EditDriverLicenseCell
            configuredCell.textFieldLicense.delegate = self

            configureLicense(for: configuredCell, with: .driverLicense)
            
            return configuredCell
        case 8:
            let configuredCell =  cell as! DeleteButtonCell
            configureDeleteButton(for: configuredCell)
            return configuredCell
            
        default: return cell
        }

    }
    
    //MARK: - CONFIGURE Block
    func configureImage(for cell: EditAvatarCell){
        
        if passedContact.hasAvatar{
            let imageSource = avatarImage ?? passedContact.image
            cell.setAvatarImageCell(with: imageSource)
        }
        
        cell.imageClosure = { [weak self] in
            if let hasAvatar = self?.passedContact.hasAvatar, hasAvatar == true {
                     
             let options = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
                let remove = UIAlertAction(title: Title.optionsChange, style: .default) { [weak self] (action) in
                guard let key = self?.passedContact.contactId else { return }
                 StorageService.removeAvatarFromStorage(path: key)
    
                 self?.passedContact.photoHasBeenUpdated = false
                 cell.imageViewAvatar.image = UIImage(named: "avatar" )
             }
             
                let change = UIAlertAction(title: Title.optionsRemove , style: .default) { [weak self] (action) in

                 self?.setImagePickerControllerActionSheet()
             }
             
                let cancel = UIAlertAction(title: Title.cancel, style: .cancel, handler: nil)
             
             options.addAction(remove)
             options.addAction(change)
             options.addAction(cancel)
             
             self?.present(options, animated: true)
             }else{
                self?.setImagePickerControllerActionSheet()
             }
        }
    }
    
    func configureNamePhoneEmailCells(for cell: EditNamePhoneEmailCell, with type: CellManagment.DataType){
        cell.update(with: CellManagment(with: passedContact, type: type))
    }
    
    func configureBirthday(for cell: EditBirthdayCell, with type: CellManagment.DataType){

        cell.update(with: CellManagment(with: passedContact, type: type))

        let birthdayPicker = UIDatePicker()
        cell.textFieldBirthday.inputView = birthdayPicker
        birthdayPicker.datePickerMode = .date
        
        let toolbar = setToolbar()
        cell.textFieldBirthday.inputAccessoryView = toolbar
        
        birthdayPicker.addTarget(self, action: #selector(getDateFromPicker(_:)), for: .valueChanged)
    }

    func configureHeight(for cell: EditHeightCell, with type: CellManagment.DataType){
        cell.update(with: CellManagment(with: passedContact, type: type))

        let heightPicker = UIPickerView()
        heightPicker.delegate = self
        
        cell.textFieldHeight.inputView = heightPicker
        
        let toolbar = setToolbar()
        cell.textFieldHeight.inputAccessoryView = toolbar
    }
    
    func configureLicense(for cell: EditDriverLicenseCell, with type: CellManagment.DataType){
        
        cell.update(with: CellManagment(with: passedContact, type: type))
        
    }
    
    func configureDeleteButton(for cell: DeleteButtonCell){
        let btnTitle = NSLocalizedString("deleteBtn", comment: "Delete button")
        
        cell.buttonDelete.setTitle(btnTitle, for: .normal)
        cell.deleteClosure = {[weak self] in
            let optionMenu = UIAlertController(title: nil, message: Title.contactRemovalConfirmation, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: Title.delete, style: .default) { [weak self] (action) in
                guard let contact = self?.passedContact else { return }
                self?.passedDataDelegate.deleteContact(deletedContact: contact)
                self?.navigationController?.popViewController(animated: true)
            }
            
            let cancelAction = UIAlertAction(title: Title.cancel, style: .cancel, handler: nil)
            optionMenu.addAction(deleteAction)
            optionMenu.addAction(cancelAction)
            self?.present(optionMenu, animated: true, completion: nil)
        }
    }

    @objc func doneAction() {
        view.endEditing(true)
    }
    
    @objc func getDateFromPicker(_ picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        guard let cell = tableView.visibleCells.filter({ return $0 is EditBirthdayCell }).first as? EditBirthdayCell else {
            return
        }
        
        let dateString = formatter.string(from: picker.date)
        passedContact.birthday = dateString
        cell.textFieldBirthday.text = dateString
    }
    
    func setToolbar() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        return toolbar
    }
    
}

//
//  ContactsListExtensions.swift
//  task9
//
//  Created by Oksana Kotilevska on 1/9/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

extension ContactsListTableViewController{
    
    private var contactCountToStartShowingSearchBar: Int{
        return 4
    }
    
    func setBackground() {
        let backgroundView = UIView()
        let addButton = UIButton()
        let label = UILabel()
        
        addButton.frame.size = CGSize(width: tableView.frame.width / 2, height: 30)
        let x: CGFloat = (tableView.frame.width / 2) - (addButton.frame.width / 2)
        let y: CGFloat = (tableView.frame.height / 2) - (addButton.frame.height / 2)
        addButton.frame.origin = CGPoint(x: x, y: y + 50.0)
        
        label.frame.size = CGSize(width: tableView.frame.width , height: 20)
        label.center = tableView.center
        
        let titleForBtn = NSLocalizedString("emptyScreenBtn", comment: "Add button on empty screen")
        addButton.setTitle(titleForBtn, for: .normal)
        addButton.setTitleColor(.blue, for: .normal)
        
        addButton.addTarget(self, action: #selector(addContact), for: .touchUpInside)
        
        let titleForLabel = NSLocalizedString("emptyScreenLabel", comment: "Label on empty screen")
        label.text = titleForLabel
        label.textColor = .black
        label.textAlignment = .center
        
        backgroundView.addSubview(label)
        backgroundView.addSubview(addButton)
        tableView.backgroundView = backgroundView
    }
    
    func checkCapacity(){
        let source = DimensionalConverter.getOneDimensionalDataSource(source: viewModel.twoDimensionalDataSource)
        navigationItem.leftBarButtonItem = source.isEmpty ? nil : editButtonItem
        
        if source.isEmpty{
            
            setBackground()
            barButtonItemPlus.isEnabled =  false
            barButtonItemPlus.tintColor = .clear
            
        }else{
            tableView.reloadData()
            tableView.backgroundView?.isHidden = true
            barButtonItemPlus.isEnabled = true
            barButtonItemPlus.tintColor = .systemBlue
            
            if source.count > contactCountToStartShowingSearchBar {
                setUpSearchController()
            }else{
                navigationItem.searchController = nil
            }
        }
    }
    
    func setUpSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    func editAfterSwipe(passedContact: ContactModel){
        let editController = UIStoryboard(name: "EditingPage", bundle: nil).instantiateViewController(identifier: "EditingPage") as! EditPageTableViewController
        
        editController.passedDataDelegate = self
        editController.passedContact = passedContact
        navigationController?.pushViewController(editController, animated: true)
    }
    
}

extension ContactsListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return viewModel.getHeader(section: section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        
        cell.nameLabel.attributedText = viewModel.getAttributedText(forRowAt: indexPath)
        
        cell.avatarImage.image = viewModel.getImage(forRowAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = viewModel.getId(indexPath: indexPath)
        
        performSegue(withIdentifier: "toContactDetails", sender: id)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            
            guard let self = self else { return }
            
            StorageService.deleteContact(keyId: self.viewModel.twoDimensionalDataSource[indexPath.section].contacts[indexPath.row].contactId! )
            
            self.viewModel.updateDataSource()
            self.checkCapacity()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, _) in
            
            guard let self = self else { return }
            
            self.editAfterSwipe(passedContact: self.viewModel.twoDimensionalDataSource[indexPath.section].contacts[indexPath.row])
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        
        return configuration
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.alphabethSet()
    }
    
}

extension ContactsListTableViewController: PassData{
    
    func passContactDetails(newContact: ContactModel) {
        
        StorageService.updateUserDefaults(with: newContact)
        
        viewModel.updateDataSource()
        checkCapacity()
    }
    
    func deleteContact(deletedContact: ContactModel) {
        
        StorageService.deleteContactAndAvatarUpdateDefaults(deletedContact: deletedContact)
        
        viewModel.updateDataSource()
        checkCapacity()
    }
}

extension ContactsListTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        viewModel.update(searchText: searchController.searchBar.text)    }
    
}

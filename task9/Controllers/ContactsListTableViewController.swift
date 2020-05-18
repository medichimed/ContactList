//
//  ContactsList.swift
//  task9
//
//  Created by Oksana Kotilevska on 12/30/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import UIKit

class ContactsListTableViewController: UITableViewController , ViewModelDelegate{
    
    let searchController = UISearchController(searchResultsController: nil)

    var searchBarIsEmpty: Bool {
        return (searchController.searchBar.text ?? "").isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var viewModel = ViewModel()
    
    @IBOutlet weak var barButtonItemPlus: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.updateDataSource()
        checkCapacity()
    }

    func viewModelDidUpdateFiltering(_ viewModel: ViewModel) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toContactDetails" else { return }
        
        guard let targetController = segue.destination as? ContactDetailsViewController else { return }
        
        guard let id = sender as? String else { return }

        guard let contact = viewModel.getContact(by: id) else { return }
        
        targetController.specificContact = contact
        targetController.passedDataDelegate = self
    }
    
   
    @objc func addContact(){
        let editController = UIStoryboard(name: "EditingPage", bundle: nil).instantiateViewController(identifier: "EditingPage") as! EditPageTableViewController
        let navigationController = UINavigationController(rootViewController: editController)
        editController.passedDataDelegate = self
        present(navigationController, animated: true)
    }
    
    @IBAction func plusButtonTapped(_ sender: UIBarButtonItem) {
        addContact()
    }
    
}



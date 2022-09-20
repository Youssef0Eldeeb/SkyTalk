//
//  UsersChatsTableViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 20/09/2022.
//

import UIKit

class UsersChatsTableViewController: UITableViewController{
    
    var allUser: [User] = []
    var filteredUser: [User] = []
    let currentUser = FirebaseAuthentication.shared.currentUser
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allUser = [
            .init(name: "Ahmed Gumma", email: "", status: ""),
            .init(name: "Hossam Khaled", email: "", status: ""),
            .init(name: "Mostafa Ali", email: "", status: ""),
            .init(name: "youssef Mossad", email: "", status: "")
        ]
        
        setupSearchBar()
    }
    
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUser.count : allUser.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleUserTableViewCell
        let user = searchController.isActive ? filteredUser[indexPath.row] : allUser[indexPath.row]
        cell.configureCell(user: user)
        
        return cell
    }
    
}


extension UsersChatsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        print(searchController.searchBar.text!.lowercased())
        
        filteredUser = allUser.filter({ user in
            return user.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    
}

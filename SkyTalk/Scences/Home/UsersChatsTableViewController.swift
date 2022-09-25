//
//  UsersChatsTableViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 20/09/2022.
//

import UIKit

class UsersChatsTableViewController: UITableViewController{
    
    var allChatRooms: [ChatRoom] = []
    var filterChatRooms: [ChatRoom] = []
    
    var allUser: [User] = []
    var shownUser: [User] = []
    var filteredUser: [User] = []
    let currentUser = FirebaseAuthentication.shared.currentUser
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadChatRooms()
        
        setupSearchBar()
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
        
    }
    
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
    }
    private func downloadChatRooms(){
        ChatManager.shared.downloadAllChatRooms { allChatRooms in
            self.allChatRooms = allChatRooms
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filterChatRooms.count : allChatRooms.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleUserTableViewCell
        let chatRoom = searchController.isActive ? filterChatRooms[indexPath.row] : allChatRooms[indexPath.row]
        cell.configure(chatRoom: chatRoom)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchController.isActive{
            // append selected chat to shownUser Array
            if  !shownUser.contains(filteredUser[indexPath.row]){
                shownUser.append(filteredUser[indexPath.row])
            }
            
            // open selected chat
            print("open selected chat")
            let chatId = ChatManager.shared.startChat(sender: currentUser!, receiver: filteredUser[indexPath.row])
        }else{
            // open selected chat
            print("open selected chat ")
            let chatId = ChatManager.shared.startChat(sender: currentUser!, receiver: shownUser[indexPath.row])
        }
    }
    private func goToChatPage(){
        
    }
    
}

// MARK: - Extension for SearchResultsUpdating

extension UsersChatsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController){
        print(searchController.searchBar.text!.lowercased())
        
        filteredUser = allUser.filter({ user in
            return user.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    
}
// MARK: - extension for scroll view delegate
extension UsersChatsTableViewController{
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl!.isRefreshing{
            self.downloadChatRooms()
            self.refreshControl!.endRefreshing()
        }
    }
}

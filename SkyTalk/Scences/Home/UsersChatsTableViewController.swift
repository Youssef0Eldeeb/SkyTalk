//
//  UsersChatsTableViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 20/09/2022.
//

import UIKit

class UsersChatsTableViewController: UITableViewController{
    
    var allShownChatRooms: [ChatRoom] = []
    var filterChatRooms: [ChatRoom] = []
    
    var allUser: [User] = []
    var filteredUser: [User] = []
    let currentUser = FirebaseAuthentication.shared.currentUser
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadChatRooms()
        
        setupSearchBar()
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
        
        downloadAllUsers()
    }
    
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    private func downloadChatRooms(){
        ChatManager.shared.downloadChatRooms { allChatRooms in
            self.allShownChatRooms = allChatRooms
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private func downloadAllUsers(){
        FirestoreManager.shared.downlaodAllUsersFromFireStore { allUsers in
            self.allUser = allUsers
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUser.count : allShownChatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleUserTableViewCell
        if searchController.isActive {
            let user = filteredUser[indexPath.row]
            cell.configureUser(user: user)
        }else{
            let chatRoom = allShownChatRooms[indexPath.row]
            cell.configureChatRoom(chatRoom: chatRoom)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchController.isActive {
            let selectedUser = filteredUser[indexPath.row]
            let currentUser = FirebaseAuthentication.shared.currentUser
            let chatId = ChatManager.shared.startChat(sender: currentUser!, receiver: selectedUser)
            print("start chat")
            goToMessagePage(user: selectedUser, chatId: chatId)
        }else{
            print("open chat")
            goToMessagePage(chatRoom: allShownChatRooms[indexPath.row])
        }
        
    }
    private func goToMessagePage(chatRoom: ChatRoom){
        ChatManager.shared.restartChat(chatRoomId: chatRoom.chatRoomId, membersIds: chatRoom.memberId)
        let privateMsgView = MassageViewController(chatId: chatRoom.chatRoomId, resipientId: chatRoom.receiverId, recipientName: chatRoom.receiverName, recipientImageLink: chatRoom.avatarLink)
        navigationController?.pushViewController(privateMsgView, animated: true)
    }
    private func goToMessagePage(user: User, chatId: String){
        let privateMsgView = MassageViewController(chatId: chatId, resipientId: user.id, recipientName: user.name, recipientImageLink: user.imageLink)
        navigationController?.pushViewController(privateMsgView, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if !searchController.isActive {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatRoom = allShownChatRooms[indexPath.row]
            ChatManager.shared.deletChatRoom(chatRoom)
            allShownChatRooms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

// MARK: - Extension for SearchResultsUpdating

extension UsersChatsTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController){
        print(searchController.searchBar.text!.lowercased())
        
        filteredUser = allUser.filter({ user in
            return user.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
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

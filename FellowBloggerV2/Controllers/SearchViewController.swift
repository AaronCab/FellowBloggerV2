//
//  SearchViewController.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/20/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class SearchViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var blogSearchBar: UISearchBar!
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    private var blogger = [Blogger](){
        didSet {
            DispatchQueue.main.async {
                self.userTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.dataSource = self
        userTableView.delegate = self
        blogSearchBar.delegate = self
        navigationItem.title = "FellowBloggerV2"
    }

}
extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogger.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UITableViewCell else { return UITableViewCell()}
        let aBlogger = blogger[indexPath.row]
        cell.textLabel?.text = aBlogger.displayName
        cell.detailTextLabel?.text = aBlogger.email
        return cell
    }
    
    
}
extension SearchViewController: UITableViewDelegate{
    
}
extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        blogger = [Blogger]()
        if searchText == ""{
            return
        } else {
            listener = DBService.firestoreDB
                .collection(BloggersCollectionKeys.CollectionKey).addSnapshotListener { [weak self] (snapshot, error) in
                    if let error = error {
                        print("failed to fetch Blogs with error: \(error.localizedDescription)")
                    } else if let snapshot = snapshot {
                        self?.blogger = snapshot.documents.map { Blogger(dict: $0.data()) }
                            .filter { $0.displayName.contains(searchText.lowercased()) || $0.displayName.contains(searchText.uppercased()) || ($0.firstName?.contains(searchText.lowercased()))! || ($0.firstName?.contains(searchText.uppercased()))!}
                    }
            }

        }
    }
}

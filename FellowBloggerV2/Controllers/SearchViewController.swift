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
        hideKeyboardWhenTappedAround()
        navigationItem.title = "FellowBloggerV2"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Profile" {
            guard let selectedIndexPath =  userTableView.indexPathForSelectedRow,
                let blogDVC = segue.destination as? BloggerProfileViewController else {
                    fatalError("cannot segue to blogDVC")
            }
            let aBlogger1 = blogger[selectedIndexPath.row]
            blogDVC.blogger = aBlogger1
        } else if segue.identifier == "Add Blog" {
            
        }
    }
    
}
extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogger.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell()}
        let aBlogger = blogger[indexPath.row]
        cell.nameLabel?.text = aBlogger.displayName
        cell.emailLabel?.text = aBlogger.email
        cell.profileImage?.kf.setImage(with: URL(string: aBlogger.photoURL ?? "no image found"), placeholder: #imageLiteral(resourceName: "icons8-check_male"))
        return cell
    }
    
}
extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

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
                            .filter { $0.displayName.contains(searchText.lowercased()) || $0.displayName.contains(searchText.uppercased()) || ($0.firstName?.contains(searchText.lowercased()))! || ($0.lastName?.contains(searchText.uppercased()))! || $0.email.contains(searchText.lowercased())}
                    }
            }

        }
    }
}


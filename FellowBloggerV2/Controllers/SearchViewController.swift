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
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        userTableView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchBlogger), for: .valueChanged)
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.dataSource = self
        userTableView.delegate = self
        navigationItem.title = "FellowBloggerV2"
        fetchBlogger()
    }
    @objc private func fetchBlogger(){
        refreshControl.beginRefreshing()
        listener = DBService.firestoreDB
            .collection(BloggersCollectionKeys.CollectionKey).addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch Blogs with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    self?.blogger = snapshot.documents.map { Blogger(dict: $0.data()) }
                        .sorted { $0.displayName > $1.displayName }
                }
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
        }

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

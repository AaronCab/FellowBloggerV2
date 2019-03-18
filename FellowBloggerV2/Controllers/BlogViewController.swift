//
//  BlogViewController.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/18/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
class BlogViewController: UIViewController {

    @IBOutlet weak var blogCollectionView: UICollectionView!
    private var blogs = [Blog](){
        didSet{
            DispatchQueue.main.async {
                self.blogCollectionView.reloadData()
            }
        }
    }
    private var blogger = [Blogger](){
        didSet{
            DispatchQueue.main.async {
                self.blogCollectionView.reloadData()
            }
        }
    }
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        blogCollectionView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchBlogs), for: .valueChanged)
        return rc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        blogCollectionView.dataSource = self
        blogCollectionView.delegate = self
        authservice.authserviceSignOutDelegate = self
        navigationItem.title = "FellowBloggerV2"
        fetchBlogs()
    }
    @objc private func fetchBlogs(){
        refreshControl.beginRefreshing()
        listener = DBService.firestoreDB
            .collection(BlogsCollectionKeys.CollectionKey).addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch dishes with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    self?.blogs = snapshot.documents.map { Blog(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date() }
                }
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
        }
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        authservice.signOutAccount()
    }
}

extension BlogViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogCell", for: indexPath) as? BlogCellCollectionViewCell else { return UICollectionViewCell()}
        let userBlog = blogs[indexPath.row]
//        let userBlogger = blogger[indexPath.row]
        cell.blogLabel.text = userBlog.blogDescription
        cell.blogImage.kf.indicatorType = .activity
        cell.blogImage.kf.setImage(with: URL(string: userBlog.imageURL), placeholder: #imageLiteral(resourceName: "icons8-check_male"))
//        cell.profileImage.kf.setImage(with: URL(string: userBlogger.photoURL!), placeholder: #imageLiteral(resourceName: "icons8-check_male"))
        return cell
    }
    
    
}
extension BlogViewController: UICollectionViewDelegate{
    
}
extension BlogViewController: AuthServiceSignOutDelegate {
    func didSignOut(_ authservice: AuthService) {
        listener.remove()
        showLoginView()
    }
    func didSignOutWithError(_ authservice: AuthService, error: Error) {}
}


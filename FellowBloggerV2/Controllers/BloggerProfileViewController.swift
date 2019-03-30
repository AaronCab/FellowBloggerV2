//
//  BloggerProfileViewController.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/21/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class BloggerProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var gradient: CAGradientLayer!

    public var blogger: Blogger!
    private lazy var profileHeaderView: ProfileHeaderView = {
        let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
        return headerView
    }()
    private let authservice = AppDelegate.authservice
    private var blogs = [Blog]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private func addGradient(){
        
        let firstColor = UIColor.init(red: 222/255, green: 98/255, blue: 98/255, alpha: 1)
        let secondColor = UIColor.init(red: 255/255, green: 184/255, blue: 140/255, alpha: 1)
        gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        profileHeaderView.delegate = self
        fetchUsersBlogs()
        updateProfileUI()
        addGradient()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile Detail View" {
            guard let selectedIndexPath =  tableView.indexPathForSelectedRow,
                let blogDVC = segue.destination as? DetailBlogViewController else {
                    fatalError("cannot segue to blogDVC")
            }
            let blog = blogs[selectedIndexPath.row]
            blogDVC.blog = blog
        } else if segue.identifier == "Add Blog" {
            
        }
    }
    private func configureTableView() {
        tableView.tableHeaderView = profileHeaderView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
    }
    
    private func updateProfileUI() {
        DBService.fetchUser(userId: blogger.bloggerId) { [weak self] (error, user) in
            if let _ = error {
                self?.showAlert(title: "Error fetching account info", message: error?.localizedDescription)
            } else if let user = user {
                self?.profileHeaderView.displayNameLabel.text = "@" + user.displayName
                guard let coverURL = user.coverImageURL,
                    !coverURL.isEmpty else {
                        return
                }
                self?.profileHeaderView.coverImage.kf.setImage(with: URL(string: coverURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))

                guard let photoURL = user.photoURL,
                    !photoURL.isEmpty else {
                        return
                }
                self?.profileHeaderView.profileImageView.kf.setImage(with: URL(string: photoURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
                self?.profileHeaderView.bioLabel.text = user.bio
            }
        }
    }
    private func fetchUsersBlogs() {
        
        let _ = DBService.firestoreDB
            .collection(BlogsCollectionKeys.CollectionKey)
            .whereField(BlogsCollectionKeys.BloggerIdKey, isEqualTo: blogger.bloggerId)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    self?.showAlert(title: "Error fetching blogs", message: error.localizedDescription)
                } else if let snapshot = snapshot {
                    self?.blogs = snapshot.documents.map { Blog(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date() }        }
        }
    }
}
extension BloggerProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell", for: indexPath) as? BlogCell else {
            fatalError("BlogCell not found")
        }
        
        let blog = blogs[indexPath.row]
        let date = blog.createdDate
        cell.selectionStyle = .none
        cell.nameLabel.text = date.formatISODateString(dateFormat: "EEE, MMM d, yyyy")
        cell.blogImageView.kf.setImage(with: URL(string: blog.imageURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
        cell.descritpionLabel.text = blog.blogDescription
        DBService.fetchUser(userId: blog.bloggerId) { [weak self] (error, user) in
            if let _ = error {
                self?.showAlert(title: "Error fetching account info", message: error?.localizedDescription)
            } else if let user = user {
                cell.blogDescriptionLabel.text = user.email
            }
        }
        return cell
    }
    
}

extension BloggerProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Profile Detail View", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.BlogCellHeight
    }
}

extension BloggerProfileViewController: ProfileHeaderViewDelegate {
    func willSignOut(_ profileHeaderView: ProfileHeaderView) {
        authservice.signOutAccount()
    }
    func willEditProfile(_ profileHeaderView: ProfileHeaderView) {
       
    }
}

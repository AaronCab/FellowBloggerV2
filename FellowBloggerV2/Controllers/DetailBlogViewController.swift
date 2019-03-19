//
//  DetailBlogViewController.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/18/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class DetailBlogViewController: UIViewController {
    public var blog: Blog!
    public var displayName: String?
    private let authservice = AppDelegate.authservice
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var blogImage: UIImageView!
    @IBOutlet weak var blogDescriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    func updateUI(){
        blogImage.kf.setImage(with: URL(string: blog.imageURL), placeholder: #imageLiteral(resourceName: "icons8-remove_user_group_man_man"))
        blogDescriptionLabel.text = blog.blogDescription
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveImageAction = UIAlertAction(title: "Save Image", style: .default) { [unowned self] (action) in
            if let image = self.blogImage.image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        let editAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] (action) in
            self.showEditView()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] (action) in
            self.confirmDeletionActionSheet(handler: { (action) in
                if user.uid == self.blog.bloggerId{
                    self.executeDelete()
                }
                
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(saveImageAction)
        if user.uid == blog.bloggerId {
            alertController.addAction(editAction)
            alertController.addAction(deleteAction)
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    private func executeDelete() {
        DBService.deleteBlog(blog: blog) { [weak self] (error) in
            if let error = error {
                self?.showAlert(title: "Error deleting blog", message: error.localizedDescription)
            } else {
                self?.showAlert(title: "Deleted successfully", message: nil, handler: { (action) in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    private func showEditView() {
        performSegue(withIdentifier: "Show Edit Blog", sender: nil)
    }

}

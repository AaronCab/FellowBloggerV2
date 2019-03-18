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
    }
}

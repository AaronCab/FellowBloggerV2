//
//  EditProfileViewController.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/21/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var profileImage: CircularButton!
    @IBOutlet weak var coverImagePhoto: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func coverImage(_ sender: UIButton) {
    }
    
    @IBAction func profileImagePressed(_ sender: CircularButton) {
    }
    
}

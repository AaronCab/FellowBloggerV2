//
//  EditBlogViewController.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/22/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class EditBlogViewController: UIViewController {
    public var blog: Blog!

    @IBOutlet weak var editDescriptionText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        editDescriptionText.text = blog.blogDescription
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

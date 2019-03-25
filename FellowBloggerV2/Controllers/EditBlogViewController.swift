//
//  EditBlogViewController.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/22/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class EditBlogViewController: UIViewController {
    public var aBlog: Blog!

    @IBOutlet weak var editDescriptionText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        editDescriptionText.text = aBlog.blogDescription
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let editDescription = editDescriptionText.text,
            !editDescription.isEmpty else {
                showAlert(title: "Missing Fields", message: "Blog Description is Required")
                return
        }
        DBService.firestoreDB
            .collection(BlogsCollectionKeys.CollectionKey)
            .document(aBlog.documentId)
            .updateData([BlogsCollectionKeys.BlogDescritionKey : editDescription
            ]) { [weak self] (error) in
                if let error = error {
                    self?.showAlert(title: "Editing Error", message: error.localizedDescription)
                }
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                self?.dismiss(animated: true)
        }
    }
}

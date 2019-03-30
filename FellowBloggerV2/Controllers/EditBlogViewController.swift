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
    private var gradient: CAGradientLayer!
    private func addGradient(){
        
        let firstColor = UIColor.init(red: 222/255, green: 98/255, blue: 98/255, alpha: 1)
        let secondColor = UIColor.init(red: 255/255, green: 184/255, blue: 140/255, alpha: 1)
        gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    @IBOutlet weak var editDescriptionText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        editDescriptionText.text = aBlog.blogDescription
        addGradient()
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

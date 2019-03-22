//
//  EditProfileViewController.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/21/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit
import Toucan
class EditProfileViewController: UIViewController {

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var profileImage: CircularButton!
    @IBOutlet weak var coverImagePhoto: UIButton!
    private var selectedImage: UIImage?
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    private var authservice = AppDelegate.authservice
    
    public var profileImageImage: UIImage!
    public var displayName: String!
    public var displayName2: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func coverImage(_ sender: UIButton) {
        var actionTitles = [String]()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionTitles = ["Photo Library", "Camera"]
        } else {
            actionTitles = ["Photo Library"]
        }
        showActionSheet(title: nil, message: nil, actionTitles: actionTitles, handlers: [{ [unowned self] photoLibraryAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
            }, { cameraAction in
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true)
            }
            ])
    }
    
    @IBAction func profileImagePressed(_ sender: CircularButton) {
        var actionTitles = [String]()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionTitles = ["Photo Library", "Camera"]
        } else {
            actionTitles = ["Photo Library"]
        }
        showActionSheet(title: nil, message: nil, actionTitles: actionTitles, handlers: [{ [unowned self] photoLibraryAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
            }, { cameraAction in
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true)
            }
            ])

    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0),
            let user = authservice.getCurrentUser(),
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let userName = userNameTextField.text,
            let bioName = bioTextView.text,
            !userName.isEmpty else {
                showAlert(title: "Missing Fields", message: "A photo and username are Required")
                return
        }
        StorageService.postImage(imageData: imageData, imageName: Constants.ProfileImagePath + user.uid) { [weak self] (error, imageURL) in
            if let error = error {
                self?.showAlert(title: "Error Saving Photo", message: error.localizedDescription)
            } else if let imageURL = imageURL {
                // update auth user and user db document
                let request = user.createProfileChangeRequest()
                request.displayName = userName
                request.photoURL = imageURL
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        self?.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
                    }
                })
                DBService.firestoreDB
                    .collection(BloggersCollectionKeys.CollectionKey)
                    .document(user.uid)
                    .updateData([BloggersCollectionKeys.PhotoURLKey    : imageURL.absoluteString,
                                 BloggersCollectionKeys.DisplayNameKey : userName,
                                 BloggersCollectionKeys.BioKey: bioName,
                                 BloggersCollectionKeys.FirstNameKey : firstName,
                                 BloggersCollectionKeys.LastNameKey : lastName
                        ], completion: { (error) in
                            if let error = error {
                                self?.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
                            }
                    })
                self?.dismiss(animated: true)
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
}
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image not available")
            return
        }
        let size = CGSize(width: 500, height: 500)
        let resizedImage = Toucan.Resize.resizeImage(originalImage, size: size)
            selectedImage = resizedImage
            profileImage.setImage(resizedImage, for: .normal)
    
       
        dismiss(animated: true)
    }
}


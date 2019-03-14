//
//  CreateAccountController.swift
//  NationalDish
//
//  Created by Alex Paul on 3/7/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class CreateAccountController: UIViewController {
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  private var authservice = AppDelegate.authservice

  
  override func viewDidLoad() {
    super.viewDidLoad()
    authservice.authserviceCreateNewAccountDelegate = self
  }
  
  @IBAction func showLoginView(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func createAccountButtonPressed(_ sender: UIButton) {
    guard let username = usernameTextField.text,
      !username.isEmpty,
      let email = emailTextField.text,
      !email.isEmpty,
      let password = passwordTextField.text,
      !password.isEmpty
    else {
        return
    }
    authservice.createNewAccount(username: username, email: email, password: password)
  }
}

extension CreateAccountController: AuthServiceCreateNewAccountDelegate {
  func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
    showAlert(title: "Account Creation Error", message: error.localizedDescription)
  }
  
    func didCreateNewAccount(_ authservice: AuthService, blogger reviewer: Blogger) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "BloggerTabController") as! UITabBarController
    mainTabBarController.modalTransitionStyle = .crossDissolve
    mainTabBarController.modalPresentationStyle = .overFullScreen
    present(mainTabBarController, animated: true)
  }
}

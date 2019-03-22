//
//  UIViewController+Navigation.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/19/19.
//  Copyright © 2019 Aaron Cabreja. All rights reserved.
//

import UIKit

extension UIViewController {
  public func showLoginView() {
    if let _ = storyboard?.instantiateViewController(withIdentifier: "BloggerTabController") as? BloggerTabBarController {
      let loginViewStoryboard = UIStoryboard(name: "LoginView", bundle: nil)
      if let loginViewController = loginViewStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
      }
    } else {
      dismiss(animated: true)
    }
  }
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


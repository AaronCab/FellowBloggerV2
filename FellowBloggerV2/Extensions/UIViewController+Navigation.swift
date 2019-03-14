//
//  UIViewController+Navigation.swift
//  NationalDish
//
//  Created by Alex Paul on 3/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
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
}


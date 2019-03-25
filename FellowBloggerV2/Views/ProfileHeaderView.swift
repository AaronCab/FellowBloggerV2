//
//  ProfileHeaderView.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/19/19.

//  Copyright © 2019 Aaron Cabreja. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
  func willSignOut(_ profileHeaderView: ProfileHeaderView)
  func willEditProfile(_ profileHeaderView: ProfileHeaderView)
}

class ProfileHeaderView: UIView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var profileImageView: CircularImageView!
  @IBOutlet weak var displayNameLabel: UILabel!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var signOutButton: UIButton!
  
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var bioLabel: UILabel!
    weak var delegate: ProfileHeaderViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
  }
  
  @IBAction func signOutButtonPressed(_ sender: UIButton) {
    delegate?.willSignOut(self)
  }
  
  @IBAction func editButtonPressed(_ sender: UIButton) {
    delegate?.willEditProfile(self)
  }
}

//
//  Blogger.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/14/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct Blogger {
    let bloggerId: String
    let displayName: String
    let email: String
    let photoURL: String?
    let coverImageURL: String?
    let joinedDate: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    public var fullName: String {
        return ((firstName ?? "") + " " + (lastName ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(userId: String,
         displayName: String,
         email: String,
         photoURL: String?,
         coverImageURL: String?,
         joinedDate: String,
         firstName: String?,
         lastName: String?,
         bio: String?) {
        self.bloggerId = userId
        self.displayName = displayName
        self.email = email
        self.photoURL = photoURL
        self.coverImageURL = coverImageURL
        self.joinedDate = joinedDate
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
    }
    
    init(dict: [String: Any]) {
        self.bloggerId = dict[BloggersCollectionKeys.BloggerIdKey] as? String ?? ""
        self.displayName = dict[BloggersCollectionKeys.DisplayNameKey] as? String ?? ""
        self.email = dict[BloggersCollectionKeys.EmailKey] as? String ?? ""
        self.photoURL = dict[BloggersCollectionKeys.PhotoURLKey] as? String ?? ""
        self.coverImageURL = dict[BloggersCollectionKeys.CoverImageURLKey] as? String ?? ""
        self.joinedDate = dict[BloggersCollectionKeys.JoinedDateKey] as? String ?? ""
        self.firstName = dict[BloggersCollectionKeys.FirstNameKey] as? String ?? "FirstName"
        self.lastName = dict[BloggersCollectionKeys.LastNameKey] as? String ?? "LastName"
        self.bio = dict[BloggersCollectionKeys.BioKey] as? String ?? "fellow bloggers are looking forward to reading your bio"
    }
}

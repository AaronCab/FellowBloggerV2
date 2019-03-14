//
//  DBService.swift
//  FellowBloggerV2
//
//  Created by Aaron Cabreja on 3/14/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct BloggersCollectionKeys {
    static let CollectionKey = "bloggers"
    static let BloggerIdKey = "bloggerId"
    static let DisplayNameKey = "displayName"
    static let FirstNameKey = "firstName"
    static let LastNameKey = "lastName"
    static let EmailKey = "email"
    static let PhotoURLKey = "photoURL"
    static let CoverImageURLKey = "coverImageURL"
    static let JoinedDateKey = "joinedDate"
    static let BioKey = "bio"
}

struct BlogsCollectionKeys {
    static let CollectionKey = "blogs"
    static let BlogDescritionKey = "blogDescription"
    static let BloggerIdKey = "bloggerId"
    static let CreatedDateKey = "createdDate"
    static let DocumentIdKey = "documentId"
    static let ImageURLKey = "imageURL"
}

final class DBService {
    private init() {}
    
    public static var firestoreDB: Firestore = {
        let db = Firestore.firestore()
        let settings = db.settings
//        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }()
    
    static public var generateDocumentId: String {
        return firestoreDB.collection(BloggersCollectionKeys.CollectionKey).document().documentID
    }
    
    static public func createBlogger(blogger: Blogger, completion: @escaping (Error?) -> Void) {
        firestoreDB.collection(BloggersCollectionKeys.CollectionKey)
            .document(blogger.bloggerId)
            .setData([ BlogsCollectionKeys.BloggerIdKey : blogger.bloggerId,
                       BloggersCollectionKeys.DisplayNameKey : blogger.displayName,
                       BloggersCollectionKeys.EmailKey       : blogger.email,
                       BloggersCollectionKeys.PhotoURLKey    : blogger.photoURL ?? "",
                       BloggersCollectionKeys.JoinedDateKey  : blogger.joinedDate,
                       BloggersCollectionKeys.BioKey         : blogger.bio ?? ""
            ]) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
    
    static public func postBlog(blog: Blog) {
        firestoreDB.collection(BlogsCollectionKeys.CollectionKey)
            .document(blog.documentId).setData([
                BlogsCollectionKeys.CreatedDateKey     : blog.createdDate,
                BlogsCollectionKeys.BloggerIdKey       : blog.bloggerId,
                BlogsCollectionKeys.BlogDescritionKey  : blog.blogDescription,
                BlogsCollectionKeys.ImageURLKey        : blog.imageURL,
                BlogsCollectionKeys.DocumentIdKey      : blog.documentId
                ])
            { (error) in
                if let error = error {
                    print("posting blog error: \(error)")
                } else {
                    print("blog posted successfully to ref: \(blog.documentId)")
                }
        }
    }
}

//
//  Post.swift
//  Social_Network_Firebase
//
//  Created by Xiaoheng Pan on 1/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import Firebase
import Foundation

class Post {
    private var _captions: String!
    private var _ImageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var captions: String {
        return _captions
    }
    
    var ImageURL: String {
        return _ImageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(captions: String, ImageURL: String, likes: Int) {
        self._captions = captions
        self._ImageURL = ImageURL
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let captions = postData["captions"] as? String {
            self._captions = captions
        }
        
        if let ImageURL = postData["ImageURL"] as? String {
            self._ImageURL = ImageURL
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}

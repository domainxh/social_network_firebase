//
//  DataService.swift
//  Social_Network_Firebase
//
//  Created by Xiaoheng Pan on 1/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

let DB_BASE = FIRDatabase.database().reference()
// This creates the reference to Firebase database. This pulls the DATABASE_URL from the google plist

let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService() //Singleton, a global class, that occurs just once.
    
    // Database References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("post")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage References
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE: FIRDatabaseReference { return _REF_BASE }
    var REF_POSTS: FIRDatabaseReference { return _REF_POSTS }
    var REF_USERS: FIRDatabaseReference { return _REF_USERS }
    var REF_POST_IMAGES: FIRStorageReference { return _REF_POST_IMAGES }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        // This goes to the user directory of firebase, If the user doesn't exist, firebase will create one, if it does exit, it will try to update it
        
        REF_USERS.child(uid).updateChildValues(userData)
    }

}

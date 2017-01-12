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

let DB_BASE = FIRDatabase.database().reference()
// This creates the reference to Firebase database. This pulls the DATABASE_URL from the google plist

class DataService {
    
    static let ds = DataService() //Singleton, a global class, that occurs just once.
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("post")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        // This goes to the user directory of firebase, If the user doesn't exist, firebase will create one, if it does exit, it will try to update it 
        
    }
    
}

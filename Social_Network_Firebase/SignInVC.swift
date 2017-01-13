//
//  ViewController.swift
//  Social_Network_Firebase
//
//  Created by Xiaoheng Pan on 1/10/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            // This check to to see if KEY_UID exist, if it does, then performSegue. This cannot be in viewDidLoad because it can only perform after the view appears.
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            // requesting permission to read email address
            
            if error != nil {
                print("Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("User cancelled Facebook authentication")
            } else {
                print("Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase - \(error)")
            } else {
                print("Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
        
    }

    @IBAction func signinTapped(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty else {
            print("The email field needs to be populated")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            print("The passworld field needs to be populated")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                print("Email user authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": user.providerID]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            } else {
                // if user doesn't exit we will create a new account for him. 
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print("Unable to create user - \(error)")
                    } else {
                        print("User created")
                        if let user = user {
                            let userData = ["provider": user.providerID]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    }
                })
                
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult)")
        
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    
    
}


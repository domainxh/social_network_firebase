//
//  FeedVC.swift
//  Social_Network_Firebase
//
//  Created by Xiaoheng Pan on 1/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("ID removed from keychain \(keychainResult)")
        
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "goToMain", sender: nil)
    }
    
}

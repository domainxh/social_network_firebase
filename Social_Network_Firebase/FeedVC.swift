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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleImageView!
    @IBOutlet weak var captionField: FancyField!
    
    var imagePicker: UIImagePickerController!
    var posts = [Post]()
    var imageSelected = false
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("Snap: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostCell {
            
            // This pulls image out of imageCache and display it on the tableView cell
            if let img = FeedVC.imageCache.object(forKey: posts[indexPath.row].ImageURL as NSString) {
                cell.configureCell(posts[indexPath.row], img: img)
                return cell
            } else {
                cell.configureCell(posts[indexPath.row])
                return cell
            }
            
        } else {
            return UITableViewCell()
        }
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // After the image is selected, get ride of the imagePicker
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("A valid image wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ID removed from keychain \(keychainResult)")
        
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToMain", sender: nil)
    }
    
    func postToFirebase(imageURL: String) {
        let post: Dictionary<String, AnyObject> = [
            "captions": captionField.text! as AnyObject,
            "ImageURL": imageURL as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        // after posting, its ideal to clear out the contents in the text field and the imagefield
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
    }
    
    @IBAction func postTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else { return }
        guard let image = imageAdd.image, imageSelected == true else { return }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            //this converts the image to imageData with 0.2 compression quality 
            
            let imageUID = NSUUID().uuidString
            // This creates unique UID for each images
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUID).put(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Unable to upload image to firebase storage: \(error)")
                } else {
                    print("Image successfully uploaded to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imageURL: url)
                    }
                }
                
            }
        }
        
    }
    
    
}

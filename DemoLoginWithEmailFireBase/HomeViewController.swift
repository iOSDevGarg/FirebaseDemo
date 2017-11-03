//
//  HomeViewController.swift
//  FirebaseTutorial
//
//  Created by James Dacombe on 16/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class HomeViewController: UIViewController {
    
    var refARtist =  DatabaseReference()
    var readData = DatabaseReference()
    var databaseHandler:DatabaseHandle?
    var postData = [String:AnyObject]()
    var artistNames = [String]()
   
    
    @IBOutlet weak var textToSave: UITextField!
    @IBOutlet weak var addnewClass: UITextField!
    @IBAction func textTosaveAction(_ sender: Any) {
        addArtist()
    }
    
    @IBAction func addClass(_ sender: Any) {
        refARtist = Database.database().reference().child(addnewClass.text!)
        let key = addnewClass.text!
        let artist = ["id":key, "artistName":addnewClass.text!]
        refARtist.child(key).setValue(artist)
        
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //Database reference to store Data
        refARtist = Database.database().reference().child("artists")
        
        let idofUser = Auth.auth().currentUser?.uid
        print(idofUser!)
    }
    
    func addArtist() {
        let key = refARtist.childByAutoId().key
        let artist:[String : AnyObject] = ["id":key as AnyObject, "artistName":textToSave.text! as AnyObject]
        refARtist.child(key).setValue(artist)
        
        let alertController = UIAlertController(title: "userCreated", message:
            "Click show userNames Now", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive,handler: { action in
            
        }))
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        var info = String()
        if UserDefaults.standard.object(forKey: "signusing") != nil {
             info = UserDefaults.standard.object(forKey: "signusing") as! String
        }
        
        if info == "Google"
        {
            if Auth.auth().currentUser != nil {
                do
                {
                    try Auth.auth().signOut()
                    GIDSignIn.sharedInstance().signOut()
                    self.dismiss(animated: false, completion: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        
        }
        else
        {
            if Auth.auth().currentUser != nil {
                do
                {
                    try Auth.auth().signOut()
//                    Auth.auth().currentUser?.delete(completion: { (err) in
//                        
//                                               
//                    })
                    self.dismiss(animated: false, completion: nil)
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func AddDataAction(_ sender: Any) {
        }
}

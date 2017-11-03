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
    //references
    var refARtist =  DatabaseReference()
    var readData = DatabaseReference()
    var databaseHandler:DatabaseHandle?
    //Dictionary to get data
    var postData = [String:AnyObject]()
    var artistNames = [String]()

    //Outlets
    @IBOutlet weak var textToSave: UITextField!
    @IBOutlet weak var addnewClass: UITextField!
    
    //Save a new user Button Action
    @IBAction func textTosaveAction(_ sender: Any) {
        addArtist()
    }
    //Save a new Class Button Action
    @IBAction func addClass(_ sender: Any) {
        refARtist = Database.database().reference().child(addnewClass.text!)
        let key = addnewClass.text!
        let artist = ["id":key, "artistName":addnewClass.text!]
        refARtist.child(key).setValue(artist)
    }
    
    //MARK: -----ViewDidLoad-----
    override func viewDidLoad() {
        super.viewDidLoad()

        //Database reference to store Data
        refARtist = Database.database().reference().child("artists")

    }
    
    //Add New user Function
    func addArtist() {
        let key = refARtist.childByAutoId().key
        let artist:[String : AnyObject] = ["id":key as AnyObject, "artistName":textToSave.text! as AnyObject]
        refARtist.child(key).setValue(artist)
        
        let alertController = UIAlertController(title: "userCreated", message:
            "Click show userNames Now", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive,handler: { action in
            
        }))
    }
    
    //Logout BUtton Action H
    @IBAction func logOutAction(sender: AnyObject) {
        var info = String()
        if UserDefaults.standard.object(forKey: "signusing") != nil {
             info = UserDefaults.standard.object(forKey: "signusing") as! String
        }
        //if login from google
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
            //if normal login
            if Auth.auth().currentUser != nil {
                do
                {
                    try Auth.auth().signOut()
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

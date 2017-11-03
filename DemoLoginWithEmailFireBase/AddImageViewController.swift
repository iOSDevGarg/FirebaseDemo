//
//  AddImageViewController.swift
//  DemoLoginWithEmailFireBase
//
//  Created by Jatin on 04/07/17.
//  Copyright © 2017 iOS-Trainee. All rights reserved.
//

import UIKit
import Firebase

class AddImageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    @IBOutlet weak var showimages: UIButton!
    @IBOutlet weak var savedImage: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var idOfUser = String()
    var refARtist =  DatabaseReference()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if appDelegate.idofuser != ""{
            idOfUser = appDelegate.idofuser
        }
        else{
            idOfUser = ""
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if idOfUser == ""
        {
            let alert : UIAlertController = UIAlertController(title: "Error", message: "No user ID Reterived", preferredStyle: .alert)
            let action  = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            showimages.isEnabled = false
            savedImage.isEnabled = false
            selectImage.isEnabled = false
            present(alert, animated: true, completion: nil)
        }
        else
        {
            refARtist = Database.database().reference().child("artists").child(idOfUser).child("imagesLinks")
        }
        Spinner.isHidden = true
    }
    
    //Present Picker
    func handleSelectProfileImageView()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: -----ImagePicker Handler-----
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker
        {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var selectImage: UIButton!
    
    //Select a new image from gallery
    @IBAction func selectImageAction(_ sender: Any) {
        handleSelectProfileImageView()
    }
    
    //Save A new image
    @IBAction func SaveImage(_ sender: Any) {
        Spinner.isHidden = false
        Spinner.startAnimating()
        DispatchQueue.global(qos: .background).async {
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                //Handler
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if let error = error
                    {
                        print(error)
                        return
                    }
                    else
                    {
                        let downloadURL = metadata?.downloadURL()?.absoluteString
                        let key = self.refARtist.childByAutoId().key
                        let artist:[String : AnyObject] = ["id":key as AnyObject, "Link":downloadURL as AnyObject]
                        self.refARtist.child(key).setValue(artist)
                    }
                })
            }
            DispatchQueue.main.async
            {
                self.Spinner.startAnimating()
                self.Spinner.isHidden = true
            }
        }
    }

    @IBAction func backAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }


}

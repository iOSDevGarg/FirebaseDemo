//
//  SignUpViewController.swift
//  FirebaseTutorial
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UIViewController {

    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Sign Up Action for email
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
        let email = emailTextField.text
        let pass = passwordTextField.text
        if emailTextField.text == "" {
            //Error
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            //Create new Account with Credentials provided
            Auth.auth().createUser(withEmail: email!, password: pass!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    //If error from server
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    //Present login screen 
    @IBAction func presentLoginScreen(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen")
        self.present(vc!, animated: true, completion: nil)
    }
}


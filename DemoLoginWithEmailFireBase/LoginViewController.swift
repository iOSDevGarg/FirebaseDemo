
//

import UIKit
import Firebase

import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    var signInInfo = String()
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self .viewDidAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            print("signed in")
            // Forward the user here straight away...
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(vc!, animated: true, completion: nil)
            
        } else {
            print ("not signed in")
            // Need to handle the forwarding once they sign in.
        }
    }
    
    //Google Sign in Button Action
    @IBAction func googleSignIn(_ sender: Any) {
        signInInfo = "Google"
        UserDefaults.standard.set(self.signInInfo, forKey: "signusing")
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            print("signed in")
            // Forward the user here straight away...
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(vc!, animated: true, completion: nil)
            
        } else {
            print ("not signed in")
            // Need to handle the forwarding once they sign in.
        }
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Error \(error)")
            return
        }
        //Get tokenCredential
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        //Sign with google Credentials
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Error \(error)")
                return
            }
        }
        
        //Save User details to Global Class
        let userID = user.userID
        let token = user.authentication.idToken
        let name = user.profile.name
        let email = user.profile.email
        let userImageUrl = user.profile.imageURL(withDimension: 200)

        // MARK: take google credentials to firebase
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.present(vc!, animated: true, completion: nil)
    }
    
   // MARK: Login Action
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
     
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    }
            }
        }
    }
 
    //Sign up screen 
    @IBAction func presentSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp")
        self.present(vc!, animated: true, completion: nil)
    }
}

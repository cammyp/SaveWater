//  LoginViewController.swift
//  savewater

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var emailEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    //MARK: OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: IB ACTION
    @IBAction func loginUsers(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailEntry.text!, password: passwordEntry.text!, completion: { (user,error) in
            
            if error == nil {
                SharedData.data.currentuser = Auth.auth().currentUser
                self.performSegue(withIdentifier: "logintoform", sender: nil)
            } else {
                let alert = UIAlertController(title: "Error",
                                              message: error?.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let alert = UIAlertController(title: "Oh No!",
                                      message: "Forgot your password? No need to worry, your data will be just fine! Go ahead and create a new login and continue tracking your water usage.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

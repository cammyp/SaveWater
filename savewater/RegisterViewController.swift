//  RegisterViewController.swift
//  savewater

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var nameEntry: UITextField!
    @IBOutlet weak var emailEntry: UITextField!
    @IBOutlet weak var passwordEntry: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    
    //MARK: OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: IB ACTION
    @IBAction func registerUsers(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailEntry.text!, password: passwordEntry.text!, completion: { (user, err) in
            
            if err == nil
            {   let userRef = SharedData.data.ref.child("users").child((user?.user.uid)!)
                let values = ["name": self.nameEntry.text, "email": self.emailEntry.text]
                userRef.setValue(values)
                SharedData.data.currentuser = Auth.auth().currentUser
                self.performSegue(withIdentifier: "registertoform", sender: nil)
            } else {
                let alert = UIAlertController(title: "Error",
                                              message: err?.localizedDescription,
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

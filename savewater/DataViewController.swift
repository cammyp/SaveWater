//  DataViewController.swift
//  savewater

import UIKit
import Firebase

class DataViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var shower: UILabel!
    @IBOutlet weak var bath: UILabel!
    @IBOutlet weak var toilet: UILabel!
    @IBOutlet weak var teeth: UILabel!
    @IBOutlet weak var hand: UILabel!
    @IBOutlet weak var glasses: UILabel!
    @IBOutlet weak var loads: UILabel!
    
    //MARK: LOCAL VARS
    var summation = 0.0
    
    
    //MARK: OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        //onload set all interface properties
        setName()
        setSummation()
        setPrecentages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: IB ACTION
    @IBAction func logoutUser(_ sender: Any) {
        try! Auth.auth().signOut()
        SharedData.data.currentuser = nil
    }
    
    
    //MARK: HELPER FUNCTIONS
    //also known as pullDataDownFromDatabase in FormViewController
    func setName(){
        let userID = Auth.auth().currentUser?.uid
        SharedData.data.ref.child("users").child(userID!).child("name").observe(DataEventType.value, with: { (snapshot) in
            
            let name = snapshot.value as? String ?? ""
            print(name)
            
            if (name.isEmpty) {
                print("name in database is empty")
            } else {
                self.nameLabel.text = name
            }
        })
    }
    
    //get/set summation
    func setSummation() {
        for (_, value) in SharedData.data.dataDict {
            self.summation = self.summation + value
        }
        self.totalLabel.text = "Total Water Use: \(self.summation) gal"
    }
    
    //set ui labels
    func setPrecentages() {
        shower.text = "\(SharedData.data.dataDict["showers"]!) gal"
        bath.text = "\(SharedData.data.dataDict["baths"]!) gal"
        toilet.text = "\(SharedData.data.dataDict["toilet"]!) gal"
        teeth.text = "\(SharedData.data.dataDict["teeth"]!) gal"
        hand.text = "\(SharedData.data.dataDict["hands"]!) gal"
        glasses.text = "\(SharedData.data.dataDict["glasses"]!) gal"
        loads.text =  "\(SharedData.data.dataDict["loads"]!) gal"
    }

}

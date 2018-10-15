//  FormViewController.swift
//  savewater

import UIKit
import Firebase
import UserNotifications

class FormViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet var stepperCollection: [UIStepper]!
    
    
    //MARK: LOCAL VAR
    let dataRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("data")
    
    
    //MARK: OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        //UID did change async listener
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if let user = user {
                SharedData.data.currentuser = Auth.auth().currentUser
                print("User is signed in with uid:", user.uid)
            } else {
                print("No user is signed in.")
            }
        }
        pullDataDownFromDatabase()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: IB ACTIONS
    //increment uitextfield
    @IBAction func stepperAction(_ sender: UIStepper) {
        if let txtField = self.view.viewWithTag(sender.tag - 1) as? UITextField {
            txtField.text = "\(sender.value)"
        }
    }
 
    //complete a series of function
    @IBAction func submitData(_ sender: Any) {
        addUserValuesToDatabaseData()
        writeToDatabaseWithAlerts()
        pushNotifications()
    }
    
    
    //MARK: HELPER FUNCTIONS
    //gets existing data from database
    func pullDataDownFromDatabase(){
        dataRef.observe(DataEventType.value, with: { (snapshot) in
            let databaseDict = snapshot.value as? [String : Double] ?? [:]
            
            if (databaseDict.isEmpty) {
                print("data in database is empty")
            } else {
                SharedData.data.dataDict = databaseDict
            }
        })
    }
    
    //add new user values to existing values in dataDict
    func addUserValuesToDatabaseData() {
        for step in stepperCollection {
            switch step.tag {
            case 3:
                SharedData.data.dataDict["baths"] = SharedData.data.dataDict["baths"]! + (step.value * 36.0)
            case 5:
                SharedData.data.dataDict["teeth"] = SharedData.data.dataDict["teeth"]! + (step.value * 1.0)
            case 7:
                SharedData.data.dataDict["hands"] = SharedData.data.dataDict["hands"]! + (step.value * 1.0)
            case 9:
                SharedData.data.dataDict["showers"] = SharedData.data.dataDict["showers"]! + (step.value * 20.0)
            case 11:
                SharedData.data.dataDict["toilet"] = SharedData.data.dataDict["toilet"]! + (step.value * 3.0)
            case 13:
                SharedData.data.dataDict["glasses"] = SharedData.data.dataDict["glasses"]! + (step.value * 0.625)
            case 15:
                SharedData.data.dataDict["loads"] = SharedData.data.dataDict["loads"]! + (step.value * 25.0)
            default:
                print("Switch Error")
            }
        }
    }
    
    //sets database values and alerts user on completion
    func writeToDatabaseWithAlerts() {
        
        for (key, value) in SharedData.data.dataDict {
            dataRef.child(key).setValue(value) {
                
                //comlpetion block with alert
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    let alert = UIAlertController(title: "Error",
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Success!",
                                                  message: "Click the View My Data button to see a breakdown of your data.",
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //add push notifications every 5 hours
    func pushNotifications() {
        
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Time to track your water useage!"
        content.badge = 1
        
        //create 5 hour interval
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 5 * hour
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: day, repeats: true)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}

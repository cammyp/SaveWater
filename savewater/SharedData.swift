//  Data.swift
//  savewater


import Foundation
import Firebase

final class SharedData {
    
    //MARK: INSTANCE VAR
    static let data = SharedData()
    
    var currentuser = Auth.auth().currentUser

    let ref = Database.database().reference(fromURL: "https://save-water-14ec1.firebaseio.com/")
    
    var dataDict = ["baths": 0.0, "teeth": 0.0, "hands": 0.0, "showers": 0.0, "toilet": 0.0, "glasses": 0.0, "loads":0.0]

}

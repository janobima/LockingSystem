//
//  WebViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 10/25/17.
//  Copyright © 2017 UNH. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class WebViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var battery: UILabel!
    @IBOutlet weak var movement: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    private var lockName: String = String()

    /// Setter function to set the name of the lock.
    ///
    /// - Parameter name: the name of the lock that is being passed to this view.
    func setLockName (name: String)
    {
        lockName = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// This function will read the data for the corresponding lock from Firebase
    /// It will display the data in the empty labels.
    ///
    /// - Parameter sender: any object
    @IBAction func readData(_ sender: Any) {

        var ref: DatabaseReference!
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("Users").child(uid!)
        
       ref.child(lockName).observe(DataEventType.value, with: { (snapshot) in
        let post = snapshot.value as? NSDictionary
        self.name.text = post?["Name"] as? String ?? ""
        self.status.text = post?["Status"] as? String ?? ""
        self.battery.text = String(describing: post?["Battery"] as? Int ?? 100)
        self.movement.text = String( describing: post?["Movement"] as? Bool ?? true)
        self.longitude.text = String( describing: post?["Longitude"] as? Double ?? 3.3)
        self.latitude.text = String( describing: post?["Latitude"] as? Double ?? 3.3)
        })
    }

    /// This function will change one of the fields in Firebase
    /// Set the status to unlocked
    ///
    /// - Parameter sender: any object
    @IBAction func changeDataUnlock(_ sender: Any) {
        var ref: DatabaseReference!
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("Users").child(uid!)
        
        // update a field in on post in firebase
        let newStatus = "unlock"
        ref.child(lockName+"/Status").setValue(newStatus)
    }
    
    /// This function will change one of the fields in Firebase
    /// Set the status to locked
    ///
    /// - Parameter sender: any object
    @IBAction func changeDataLock(_ sender: Any) {
        var ref: DatabaseReference!
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("Users").child(uid!)
         // update a field in on post in firebase
         let newStatus = "locked"
         ref.child(lockName+"/Status").setValue(newStatus)
    }

}

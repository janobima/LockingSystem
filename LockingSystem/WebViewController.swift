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
    
    @IBAction func readData(_ sender: Any) {

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // Retrieve posts and listen for changes in a post in Firebase
         ref.child("Posts").child(lockName).observeSingleEvent(of: .value, with: { (snapshot) in
            let post = snapshot.value as? NSDictionary
            
            self.name.text = post?["Name"] as? String ?? ""
            self.status.text = post?["Status"] as? String ?? ""
            self.battery.text = String(describing: post?["Battery"] as? Int ?? 100)
            self.movement.text = String( describing: post?["Movement"] as? Bool ?? true)
            self.longitude.text = String( describing: post?["Longitude"] as? Double ?? 3.3)
            self.latitude.text = String( describing: post?["Latitude"] as? Double ?? 3.3)
        })
    }

    @IBAction func changeDataUnlock(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // update a field in on post in firebase
        let newStatus = "unlock"
        ref.child("Posts/"+lockName+"/Status").setValue(newStatus)
        readData(AnyObject.self)
        
    }
    @IBAction func changeDataLock(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
         // update a field in on post in firebase
         let newStatus = "locked"
         ref.child("Posts/"+lockName+"/Status").setValue(newStatus)
        readData(AnyObject.self)
    }

}

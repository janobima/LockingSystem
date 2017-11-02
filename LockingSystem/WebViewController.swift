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
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var battery: UILabel!
    @IBOutlet weak var movement: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    let lockName = "Lock1"
    /*
    struct ServerLock: Codable{
        let id: Int
        let Status: String
        let Battery: Int
        let Movement: Bool
        let Longitude: Double//CLLocationDegrees
        let Latitude: Double//CLLocationDegrees
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        configFireBase();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configFireBase()
    {
        // set the firebase reference
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
         // create a new post and write it to firebase
        let name = "mylock"
        let status = "Locked"
        let battery = 90
        let movement = true
        let longitude = -72.9613023
        let latitude = 41.296486
        let post :[String : AnyObject] = ["Name" : name as AnyObject, "Status": status as AnyObject, "Battery":battery  as AnyObject,"Movement": movement as AnyObject,"Longitude": longitude as AnyObject, "Latitude":latitude as AnyObject ]
        //let newRef = ref.child("Posts").childByAutoId().setValue(post)
        ref.child("Posts").child(lockName).setValue(post)
    }
    
    @IBAction func readData(_ sender: Any) {

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // Retrieve posts and listen for changes in a post in Firebase
        let handle = ref.child("Posts").child(lockName).observeSingleEvent(of: .value, with: { (snapshot) in
            let post = snapshot.value as? NSDictionary
            let lockName = post?["Name"] as? String ?? ""
            self.status.text = post?["Status"] as? String ?? ""
            self.battery.text = String(describing: post?["Battery"] as? Int ?? 100)
            self.movement.text = String( describing: post?["Movement"] as? Bool ?? true)
            self.longitude.text = String( describing: post?["Longitude"] as? Double ?? 3.3)
            self.latitude.text = String( describing: post?["Latitude"] as? Double ?? 3.3)
        })
        /*
        guard let url = URL(string:"https://raw.githubusercontent.com/janobima/LockingSystem/master/myJSON.json") else {return}
        URLSession.shared.dataTask(with: url) {(data,response,err)in
            guard let data = data else {return}
            do{
                let myServerLocks = try
                    JSONDecoder().decode([ServerLock].self, from: data)
                
                DispatchQueue.main.async {
                    self.status.text = myServerLocks[0].Status
                    self.battery.text = String(myServerLocks[0].Battery)
                    self.movement.text = String(myServerLocks[0].Movement)
                    self.longitude.text = String( myServerLocks[0].Longitude)
                    self.latitude.text = String(myServerLocks[0].Latitude)
                }
            }
            catch {
                print("Error serializing JSON")
            }
            }.resume()
 */
        
    }

    
    @IBAction func changeDataUnlock(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // update a field in on post in firebase
        let newStatus = "unlock"
        ref.child("Posts/"+lockName+"/Status").setValue(newStatus)
        readData(AnyObject)
        
    }
    @IBAction func changeDataLock(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
         // update a field in on post in firebase
         let newStatus = "locked"
         ref.child("Posts/"+lockName+"/Status").setValue(newStatus)
        readData(AnyObject)
        
        /*guard let url = URL(string: "https://raw.githubusercontent.com/janobima/LockingSystem/master/myJSON.json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let newLock = ServerLock(id: 3, Status: "UNLOCKED", Battery: 40, Movement: false,Longitude: -72.9, Latitude: 34.5)
        print("my new lock before encoding")
        print(newLock)
        do {
            let jsonBody = try JSONEncoder().encode(newLock)
            request.httpBody = jsonBody
            print("my new lock after encoding")
            print(jsonBody)
        } catch {}

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, _, _) in
            guard let data = data else { return }
            do {
                print("my new lock before decoding")
                let myServerLocks = try
                    JSONDecoder().decode([ServerLock].self, from: data)
                print("my new lock after decoding")
                print(myServerLocks)

            } catch {}
        }
        task.resume()*/
    }

}

//
//  ListViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 9/20/17.
//  Copyright © 2017 UNH. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ListViewController: UIViewController,UITableViewDelegate , UITableViewDataSource{
    //--------------------------------------------------
    var locksarr: [String] = []
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    //--------------------------------------------------
    @IBOutlet weak var tableView: UITableView!
    
    /// This function is to segue to the NewLock view.
    /// It checks if the user is logged in, otherwise, it will not perform the segue.
    ///
    /// - Parameter sender: any object
    @IBAction func newLock(_ sender: Any) {
         if Auth.auth().currentUser?.email != nil {
            performSegue(withIdentifier: "toNewView", sender: nil)
        }
        else
         {
            print("You are not logged in, therefore, you can not create a new lock!")
        }
    }
  
    /// This function will be called after the view is loaded.
    /// It will check if the user is logged in, and fetch the data from Firebase
    /// It will display the data in the table view.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if Auth.auth().currentUser?.email != nil {
            print ("You are an authenticated user.")
            ref = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
            databaseHandle = ref?.observe(.childAdded , with: { (snapshot) in
            // add snapshots data to the array
            let post = snapshot.value as? NSDictionary
            let name = post?["Name"] as? String
            self.locksarr.insert(name! , at: 0)
            self.tableView.reloadData()
            })
        }
        else
        {
            print("Your are not logged in.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Set the number of sections in the table view
    ///
    /// - Parameter tableView: UITableView
    /// - Returns: integer which is the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Set the number of rows in the table view
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: integer
    /// - Returns: integer which is the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locksarr.count
    }
    
    
    /// Set the cells feilds in the table view to the data in the locks array.
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: index path of the cell
    /// - Returns: table cell
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lockCell", for: indexPath)
        cell.textLabel?.text =  locksarr[indexPath.row]
        return cell
    }
    
    /// Adding the delete functionality to the table view
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - editingStyle: delete or insert
    ///   - indexPath: index path of the cell
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let myCurrentLock = locksarr[indexPath.row]
            // -------------------------------------------------------------------
            // delete the data from firebase
            var ref: DatabaseReference!
            ref = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)

            ref.child(myCurrentLock).removeValue()
            locksarr.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    /// Adding the selection functionality to the table view
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: index path of the selected cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    /// Preparing for segue to the next view
    /// Passing the data to the next view by calling its setter function.
    ///
    /// - Parameters:
    ///   - segue: name of segue
    ///   - sender: any object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatus"{
            let vc = segue.destination as! UINavigationController
            let StatusViewController = vc.topViewController as! StatusViewController
            
            if let indexpath = self.tableView.indexPathForSelectedRow
            {
                StatusViewController.setCatchedLock(newLock: locksarr[indexpath.row])
            }
        }
    }
    
}
extension UIViewController
{
    /// create a swipe gesture recognizer
    ///
    /// - Parameter swipe: UISwipeGestureRecognizer
    func doSwipeUser(swipe: UISwipeGestureRecognizer)
    {
        switch swipe.direction.rawValue{
        case 2:
            if (shouldPerformSegue(withIdentifier: "toUser",sender: self) == true)
            { performSegue(withIdentifier: "toUser", sender: self) }
        default:
            break
        }
    }
}


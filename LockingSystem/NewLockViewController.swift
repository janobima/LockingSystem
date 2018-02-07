//
//  NewLockViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 9/19/17.
//  Copyright © 2017 UNH. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class NewLockViewController: UIViewController ,UITextFieldDelegate{
    // Properties ---------------------------
    
    var myuser: User!

    // outlets -------------------------------
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imeiField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self , action: #selector(self.dismissKeyboard)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Function to limit the number of characters in the text fields ----------------
    ///
    /// - Parameters:
    ///   - textField: UITextField being selected
    ///   - range: NSRange of characters
    ///   - string: replacement String
    /// - Returns: True/False
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField {
            if range.length + range.location > (nameField.text?.count)! {
                return false
            }
            let namelength = (nameField.text?.count)! + string.count - range.length
            return namelength <= 20
        }
        return true
    }
    
    /// Dismiss the keyboard
    ///
    /// - Parameter textField: UITextField being selected
    /// - Returns: True/False
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        dismissKeyboard()
        return true
    }
    @objc func dismissKeyboard() {
        nameField.resignFirstResponder()
    }
    
    /// create a new lock with default data and save it to Firebase
    ///
    /// - Parameter sender: Any object
    @IBAction func finish(_ sender: Any) {
        if (shouldPerformSegue(withIdentifier: "toList",sender: self) == true)
        {
            
        }
    }
    
    /// creating an alert view
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message in the alert
    func createAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("OK button is pressed")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    func isExists(name: String )-> Bool
    {
        var exist = false
        
        // set the firebase reference
        var ref: DatabaseReference!
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("Users").child(uid!)
        
        ref.observeSingleEvent(of: .value  , with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                   // print("key = \(key)  name = \(name)")
                    if (key == name)
                    {
                    print("already exists")
                    exist = true
                    break
                    }
            }
        })
        ref.removeAllObservers()
        print(exist)
        return exist
    }*/
    
    /// show the alerts before performing the segue
    ///
    /// - Parameters:
    ///   - withIdentifier: name of segue
    ///   - sender: any object
    /// - Returns: True/False
    override func shouldPerformSegue(withIdentifier: String?,sender: Any?) -> Bool
    {
        if (withIdentifier == "toList")
        {
            if ((nameField.text?.isEmpty)!)
            {
                createAlert(title: "Please enter a name!", message: "")
                return false
            }
            if ((imeiField.text?.isEmpty)!)
            {
                createAlert(title: "Please enter an IMEI#!", message: "")
                return false
            }
            // --------------------------------------------------------------
            // set the firebase reference
            var ref: DatabaseReference!
            let uid = Auth.auth().currentUser?.uid
            ref = Database.database().reference()
            
            // create a new post and write it to firebase
            let name = nameField.text!
            let imei = imeiField.text!
            var flag = false ;
            ref.child("Users").child(uid!).child("Locks").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(name){
                    self.createAlert (title:"Error!", message:"The name is already used. Please re-try with a new name.")
                    flag = false;
                }
                else {flag = true;}
            })
            ref.child("Locks").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(imei){
                    ref.child("Users").child(uid!).child("Locks").child(name).child("IMEI").setValue(imei);
                    flag = true;
                }else{
                    self.createAlert (title:"Error!", message:"The IMEI number that you have entered is not valid. Please re-try with a valid IMEI.")
                    flag = false;
                }
            })
            return flag;
        }
        else
        { return true; }
    }
}
extension UIViewController
{
    /// Function to create a swipe gesture
    ///
    /// - Parameter swipe: SwipeGestureRecognizer
    func doSwipeList(swipe: UISwipeGestureRecognizer)
    {
        switch swipe.direction.rawValue{
        case 2:
            if (shouldPerformSegue(withIdentifier: "swipeList",sender: self) == true)
            { performSegue(withIdentifier: "swipeList", sender: self) }
        default:
            break
        }
    }
}


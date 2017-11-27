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
            // --------------------------------------------------------------
            // set the firebase reference
            var ref: DatabaseReference!
            let uid = Auth.auth().currentUser?.uid
            ref = Database.database().reference().child("Users").child(uid!)
            
            // create a new post and write it to firebase
            let name = nameField.text!
            let status = "Unlocked"
            let battery = 100
            let movement = false
            let longitude = -72.9613023
            let latitude = 41.296486
            let post :[String : AnyObject] = ["Name" : name as AnyObject, "Status": status as AnyObject, "Battery":battery  as AnyObject,"Movement": movement as AnyObject,"Longitude": longitude as AnyObject, "Latitude":latitude as AnyObject ]
           // ref.child("users/\(String(describing: uid))").child(nameField.text!).setValue(post)
            ref.child(nameField.text!).setValue(post)

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
            else
            {  return true;  }
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


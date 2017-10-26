//
//  NewLockViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 9/19/17.
//  Copyright © 2017 UNH. All rights reserved.
//

import UIKit
import CoreData

class NewLockViewController: UIViewController ,UITextFieldDelegate{
    
    // outlets -------------------------------
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var pass1Field: UITextField!
    @IBOutlet weak var pass2Field: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.delegate = self
        self.pass1Field.delegate = self
        self.pass2Field.delegate = self
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
        if textField == pass1Field {
            if range.length + range.location > (pass1Field.text?.count)! {
                return false
            }
            let pass1length = (pass1Field.text?.count)! + string.count - range.length
            return pass1length <= 8
        }
        if textField == pass2Field {
            if range.length + range.location > (pass2Field.text?.count)! {
                return false
            }
            let pass2length = (pass2Field.text?.count)! + string.count - range.length
            return pass2length <= 8
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
    func dismissKeyboard() {
        nameField.resignFirstResponder()
        pass1Field.resignFirstResponder()
        pass2Field.resignFirstResponder()
    }
    
    /// create a new lock and save it to core data
    ///
    /// - Parameter sender: Any object
    @IBAction func finish(_ sender: Any) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if (shouldPerformSegue(withIdentifier: "toList",sender: self) == true)
        {
            let myLock = NSEntityDescription.insertNewObject(forEntityName: "Lock", into: context)
            myLock.setValue(nameField.text!, forKey: "name")
            myLock.setValue(pass1Field.text!, forKey: "passcode")
            do{
                try context.save()
            }catch {
                print("Error occurred during the save")
            }
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
            if ((nameField.text?.isEmpty)! && (pass1Field.text?.isEmpty)!&&(pass2Field.text?.isEmpty)!)
            {
                createAlert(title: "Please enter a name and a passcode!", message: "")
                return false
            }
            else if (nameField.text?.isEmpty)!
            {
                 createAlert(title: "Please enter a name for the lock!", message: "")
                return false
            }
            else if (pass1Field.text?.isEmpty)!
            {
                 createAlert(title: "Please enter a passcode !", message: "")
                return false
            }
            else if (pass2Field.text?.isEmpty)!
            {
                 createAlert(title: "Please re-enter the passcode !", message: "")
                return false
            }
            else if ((pass2Field.text) != (pass1Field.text))
            {
                 createAlert(title: "Confirmation passcode does not match the\n passcode, please re-enter!", message: "")
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


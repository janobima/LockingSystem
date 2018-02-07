//
//  SignupViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 11/2/17.
//  Copyright © 2017 UNH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController  ,UITextFieldDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
   // @IBOutlet weak var usernameField: UITextField!
    
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

    /// This function will be triggered once the login button is clicked,
    /// It will handle the user authentication to Firebase using email & password.
    ///
    /// - Parameter sender: object from any type
    @IBAction func login(_ sender: Any) {
        if ( !(emailField.text?.isEmpty)! && !(passwordField.text?.isEmpty)! && isValidEmail(email: emailField.text!) )
        {
            if segmentControl.selectedSegmentIndex == 0
            {
                // login
                Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                    if (user != nil) // login successful
                    {
                        print("login successful")

                        self.performSegue(withIdentifier: "fromLoginToList", sender: self)
                    }
                    else
                    {
                        if let myError = error?.localizedDescription
                        {
                            self.createAlert(title: myError, message: "")
                            print(myError)
                        }
                        else
                        {
                            print("Error!")
                        }
                    }
                }
            }
            else{
                // sign up
                Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                    if (user != nil)// successful sign up
                    {
                        Auth.auth().signIn(withEmail: self.emailField.text!,
                                           password: self.passwordField.text!)
                        print("sign up successful")
                        
                        let ref: DatabaseReference!
                        let uid = Auth.auth().currentUser?.uid
                        ref = Database.database().reference().child("Users").child(uid!)
                        self.performSegue(withIdentifier: "fromLoginToList", sender: self)
                    }
                    else
                    {
                        if let myError = error?.localizedDescription
                        {
                            print(myError)
                        }
                        else
                        {
                            print("Error!")
                        }
                    }
                }
            }
        }else
        {
            print ("Please enter your email and password")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.passwordField.delegate = self;        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self , action: #selector(self.dismissKeyboard)))
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
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromLoginToList"{
            let vc = segue.destination as! UINavigationController
            let UserViewController = vc.topViewController as! UserViewController
            UserViewController.setUsername(usrname:usernameField.text! )
        }
    }*/
    
    /// This function validate the email address by comparing it to the email format
    ///
    /// - Parameter email: the email address that was entered by the user
    /// - Returns: true if valid email format, false otherwise
    func isValidEmail(email: String) ->Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

}
extension UIViewController
{
    /// create a swipe gesture recognizer
    ///
    /// - Parameter swipe: UISwipeGestureRecognizer
    func doSwipeHome2(swipe: UISwipeGestureRecognizer)
    {
        switch swipe.direction.rawValue{
        case 2:
            if (shouldPerformSegue(withIdentifier: "toHome2",sender: self) == true)
            { performSegue(withIdentifier: "toHome2", sender: self) }
        default:
            break
        }
    }
}



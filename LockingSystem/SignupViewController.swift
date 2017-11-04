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

class SignupViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func login(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
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
                        print("sign up successful")
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
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
       // let userEmail = Auth.auth().currentUser?.email
        
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



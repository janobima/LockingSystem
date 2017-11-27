//
//  UserViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 11/22/17.
//  Copyright © 2017 UNH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserViewController: UIViewController {

//private var myUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // username.text! = myUserName!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   // @IBOutlet weak var username: UILabel!
   /* func setUsername(usrname : String)
    {
        myUserName = usrname
    }*/
    
    /// This function will be called when the user clicks teh logout button.
    /// It will check if the user is logged in, will sign out out from Firebase
    /// and will print an error messages if any error has occured.
    ///
    /// - Parameter sender: any object
    @IBAction func logout(_ sender: Any) {
        if Auth.auth().currentUser?.email != nil {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            print("You have logged out successfully!")
            performSegue(withIdentifier: "progSegue", sender: nil)
        }
        else {
            print("You can not log out.")
        }
    }
    
    @IBAction func changePass(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Password",
                                      message: "Type your new password",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        // 1
                                        guard let textField = alert.textFields?.first,
                                            let password = textField.text
                                            else { return }
                                        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                            
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
      
    }
    
}
extension UIViewController
{
    /// create a swipe gesture recognizer
    ///
    /// - Parameter swipe: UISwipeGestureRecognizer
    func doSwipeHome3(swipe: UISwipeGestureRecognizer)
    {
        switch swipe.direction.rawValue{
        case 2:
            if (shouldPerformSegue(withIdentifier: "toHome",sender: self) == true)
            { performSegue(withIdentifier: "toHome", sender: self) }
        default:
            break
        }
    }
}


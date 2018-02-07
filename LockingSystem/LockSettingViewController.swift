//
//  LockSettingViewController.swift
//  LockingSystem
//
//  Created by Ali Hassan AlJanobi on 2/5/18.
//  Copyright © 2018 UNH. All rights reserved.
//

import UIKit
import UserNotifications
import Foundation
import Firebase

class LockSettingViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate  {
    private let uid = Auth.auth().currentUser?.uid
    private var lockname: String?
    private var lockIMEI: String?

    private let ref = Database.database().reference()
    
    func setLockName (newLock: String)
    {
        lockname = newLock
    }
    func setLockIMEI (newLock: String)
    {
        lockIMEI = newLock
    }
    
    let units = ["Miles","Feet","Meters","Kilometers"]
    var currentUnit = 0  // 0 = mile, 1 = feet, 2= meters, 3=kilometer
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentUnit = row
    }
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBAction func changeName(_ sender: Any) {
        /*
         update the name in firebase
         */
      //  ref.child("Users").child(uid!).child("Locks").child(lockname!).set(nameLabel.text)
       // lockname = nameLabel.text
        createAlert(title: "Your lock's name has been updated",
                    message: "New name:" + nameLabel.text!)
    }
    @IBAction func setLocation(_ sender: Any) {
     /* read the current long/lat from firebase
       store them in the initial location's field in firebase */
        var safeLat = "4"
        var safeLon = "4"
        ref.child("Locks").child(lockIMEI!).observe(DataEventType.value, with: {(snapshot) in
            let post = snapshot.value as? NSDictionary
            
            safeLat = String(describing: post?["Lat"] as! String)
            safeLon  = String(describing: post?["Lon"] as! String)
            
            self.ref.child("Users").child(self.uid!).child("Locks").child(self.lockname!).child("safeLat").setValue(safeLat)
            self.ref.child("Users").child(self.uid!).child("Locks").child(self.lockname!).child("safeLon").setValue(safeLon)
             })
        createAlert(title: "Your initial location has been updated to the current location of your locking unit",
                    message: "")

    }
    @IBOutlet weak var pickUnit: UIPickerView!
    @IBOutlet weak var radiusValue: UITextField!
    
    @IBAction func setSafeZone(_ sender: Any) {
        /*
         take the values of the picker and the radius
         store them in firebase unit and radius fields
         */
        ref.child("Users").child(uid!).child("Locks").child(lockname!).child("Unit").setValue(currentUnit)
        ref.child("Users").child(uid!).child("Locks").child(lockname!).child("Radius").setValue(radiusValue.text)
    
        createAlert(title: "Your safe zone preferences have been updated",
                    message: "Radius: " + radiusValue.text! + " Unit: " + units[currentUnit])

    }
    
    func createAlert (title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("OK button is pressed")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickUnit.delegate = self
        pickUnit.dataSource = self
        
        self.radiusValue.delegate = self
        self.nameLabel.delegate = self;
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self , action: #selector(self.dismissKeyboard)))
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
        nameLabel.resignFirstResponder()
        radiusValue.resignFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  StatusViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 9/19/17.
//  Copyright © 2017 UNH. All rights reserved.
//

import UIKit
import UserNotifications
import Foundation
import Firebase

class StatusViewController: UIViewController{
    
    private let uid = Auth.auth().currentUser?.uid
   // private let ref = Database.database().reference().child("Users")
    private var catchedlock: String?
    private var catchedIMEI: String?

    @IBOutlet weak var lockName: UILabel!
    @IBOutlet weak var controlSwitch: UISwitch!
    private let ref = Database.database().reference().child("Locks")

    /// This is a setter function to set the name of the lock to send to this class.
    ///
    /// - Parameter newLock: the name of the lock that is being sent from the previous view
    func setCatchedLock (newLock: String)
    {
        catchedlock = newLock
    }
    func setcatchedIMEI (newLock: String)
    {
        catchedIMEI = newLock
    }
    
    /// This function is called when the switch is toggled to change the status of the switch
    ///
    /// - Parameter sender: any object
    @IBAction func lockSwitch(_ sender: Any) {
        if (controlSwitch.isOn==false)
        {
       //     let newStatus = "unlock"
            //ref.child(uid!).child(catchedlock!+"/Status").setValue(newStatus)
            ref.child(catchedIMEI!).child("Stat").setValue("1")
            controlSwitch.setOn(true, animated: true)
        }
        else {
//            let newStatus = "lock"
            //ref.child(uid!).child(catchedlock!+"/Status").setValue(newStatus)
            ref.child(catchedIMEI!).child("Stat").setValue("0")
            controlSwitch.setOn(false, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lockName.text! = catchedlock!
        readData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// A function to test the status of the lock
    ///
    /// - Parameter status: the current status of the lock "locked"/"unlocked"
    /// - Returns: true if status = "locked, false otherwise
    func isLocked(status: String) -> Bool
    {
        return status == "lock"
    }
    
    /// A function to return the corresponding battery image of the current battery value
    /// 0: Green Battery    1: Yellow Battery   2: Orange Battery   3:Red Battery
    ///
    /// - Parameter value: and integer that represents the current battery value
    /// - Returns: the corresponding battery image from [0-3]
    func batteryImage(value : Int) -> Int{
        if ( value > 75)
        {  return 0 }
        else if (value > 50)
        {  return 1 }
        else if (value > 25)
        {  return 2 }
        else if (value > 0)
        {  return 3 }
        return 0
    }
    
    /// This function reads the data from firebase each time the data is updated
    /// It reflects the data into the UI components
    func readData()
    {
       // ref.child(uid!).child(catchedlock!).observe(DataEventType.value, with: { (snapshot) in
        ref.child(catchedIMEI!).observe(DataEventType.value, with: { (snapshot) in
       
        let post = snapshot.value as? NSDictionary
        
        //if ( self.isLocked(status: (post?["Status"] as? String)!) ){
        if ( post?["Stat"] as? Bool == true ){
            self.controlSwitch.setOn(false, animated: true)
        }
        else{
            self.controlSwitch.setOn(true, animated: true)
        }
        
        let images = [UIImage(named: "greenBattery.png"), UIImage(named: "yellowBattery.png"),UIImage(named: "orangeBattery.png"),UIImage(named: "redBattery.png")]
        
        //self.batteryLabel.text = String(describing: post?["Battery"] as? Int ?? 0)
            //text.toInt()
        //self.batteryLabel.text = String(describing: post?["Bat"] as? Int ?? 0)
            self.batteryLabel.text = String(describing: post?["Bat"] as! String)
        
            //let batteryValue = Int(post?["Battery"] as? Int ?? 0)
        //let batteryValue = Int(post?["Bat"] as? Int ?? 0)
            let batteryValue = Int(self.batteryLabel.text!)
            
            self.picture.image = images[ self.batteryImage(value:batteryValue!) ]
        
       // if (post?["Movement"] as? Bool == true)
        if (post?["Tamp"] as? Bool == true)
        {
            self.alarm2(AnyObject.self)
        }
    })
    }

    @IBOutlet weak var batteryLabel: UILabel!
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBAction func track(_ sender: Any) {
    }

    /// Add a response to the notification
    ///
    /// - Parameters:
    ///   - center: UNUserNotificationCenter
    ///   - response: user response
    ///   - completionHandler: @escaping
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if response.actionIdentifier ==  UNNotificationDismissActionIdentifier
        { print ("dismiss") }
        else if response.actionIdentifier == "option1"
        { print ("Track!") }
        completionHandler()
    }
    
    /// Trigger the notification #2
    ///
    /// - Parameter sender: any object
    func alarm2(_ sender: Any) {
        let option1 = UNNotificationAction(identifier: "option1", title: "Track it", options: UNNotificationActionOptions.foreground)
        let category = UNNotificationCategory(identifier: "myCategory", actions: [option1], intentIdentifiers: [], options: [] )
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Create a notification
        let content = UNMutableNotificationContent()
        content.title = "Alarming Condition!"
        content.body = "Your lock might been tampered with!"
        content.badge = 1
        content.sound = UNNotificationSound.init(named: "definite.m4a")
        content.categoryIdentifier = "myCategory"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in })
    }
    
    /// This function is called before segueing to the next view
    /// It will call the setter function for the next view in order
    /// to pass the data to it.
    ///
    /// - Parameters:
    ///   - segue: the type of segue
    ///   - sender: any object can trigger this function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap"{
            let vc = segue.destination as! UINavigationController
            let mapvc = vc.topViewController as! MapViewController
            mapvc.setLockName(newLock: catchedlock! )
            mapvc.setIMEI(newLock: catchedIMEI! )
        }
        if segue.identifier == "toLockSetting"{
            let vc = segue.destination as! UINavigationController
            let mapvc = vc.topViewController as! LockSettingViewController
            mapvc.setLockName(newLock: catchedlock! )
            mapvc.setLockIMEI(newLock: catchedIMEI! )
        }
        
    }
    
}
extension UIViewController
{
    /// create a swipe gesture recognizer
    ///
    /// - Parameter swipe: UISwipeGestureRecognizer
    func doSwipe(swipe: UISwipeGestureRecognizer)
    {
        switch swipe.direction.rawValue{
        case 2:
            if (shouldPerformSegue(withIdentifier: "toList",sender: self) == true)
            { performSegue(withIdentifier: "toList", sender: self) }
        default:
            break
        }
    }
}

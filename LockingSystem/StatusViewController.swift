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
    private let ref = Database.database().reference().child("Users")
    private var catchedlock: String?

    @IBOutlet weak var lockName: UILabel!
    @IBOutlet weak var controlSwitch: UISwitch!

    /// This is a setter function to set the name of the lock to send to this class.
    ///
    /// - Parameter newLock: the name of the lock that is being sent from the previous view
    func setCatchedLock (newLock: String)
    {
        catchedlock = newLock
    }
    
    /// This function is called when the switch is toggled to change the status of the switch
    ///
    /// - Parameter sender: any object
    @IBAction func lockSwitch(_ sender: Any) {
        if (controlSwitch.isOn==false)
        {
            let newStatus = "unlock"
            ref.child(uid!).child(catchedlock!+"/Status").setValue(newStatus)
            controlSwitch.setOn(true, animated: true)
        }
        else {
            let newStatus = "lock"
            ref.child(uid!).child(catchedlock!+"/Status").setValue(newStatus)
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

    func readData()
    {
    ref.child(uid!).child(catchedlock!).observe(DataEventType.value, with: { (snapshot) in
        let post = snapshot.value as? NSDictionary
        
        if (post?["Status"] as? String == "lock"){
            self.controlSwitch.setOn(false, animated: true)
        }
        else{
            self.controlSwitch.setOn(true, animated: true)
        }
        
        let images = [UIImage(named: "greenBattery.png"), UIImage(named: "yellowBattery.png"),UIImage(named: "orangeBattery.png"),UIImage(named: "redBattery.png")]
        
        self.batteryLabel.text = String(describing: post?["Battery"] as? Int ?? 0)
        let batteryValue = Int(post?["Battery"] as? Int ?? 0)
        
        if ( batteryValue > 75)
        {  self.picture.image = images[0] }
        else if (batteryValue > 50)
        {  self.picture.image = images[1] }
        else if (batteryValue > 25)
        {  self.picture.image = images[2] }
        else if (batteryValue > 0)
        {  self.picture.image = images[3] }
        
        if (post?["Movement"] as? Bool == true)
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
        content.sound = UNNotificationSound.default()
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

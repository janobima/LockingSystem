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
import CoreData
import Firebase

class StatusViewController: UIViewController{
    
    private var catchedlock: Lock?

    private var myName: String = String()
    private var myPass: String = String()
    private var passTextField :UITextField?

    @IBOutlet weak var lockName: UILabel!
    @IBOutlet weak var controlSwitch: UISwitch!
    
    func setCatchedLock (newLock: Lock)
    {
        catchedlock = newLock
    }
    @IBAction func lockSwitch(_ sender: Any) {
        if (controlSwitch.isOn==false)
        {
            let alert = UIAlertController(title: "Enter password to unlock", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: passTextField)
            let ok = UIAlertAction(title: "OK", style: .default, handler: self.okHandler)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert,animated:true)
        }
        else {
            controlSwitch.setOn(false, animated: true)
            print("ok handler: locked \n")
            //post(status: "Locked");
        }
    }

    func passTextField(textField: UITextField)
    {
        passTextField = textField
        passTextField?.isSecureTextEntry = true
    }
    
    func okHandler(alert: UIAlertAction)
    {
        if(passTextField?.text == myPass)
        {
                controlSwitch.setOn(true, animated: true)
                print("ok handler: unlocked \n")
              //  post(status: "Unlocked");
        }
        else
        {
            passTextField?.text = "Wrong passcode, please re-enter"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myName = (catchedlock?.name)!
        myPass = (catchedlock?.passcode)!
        lockName.text! = myName
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    func post(status : String)
    {
        let post :[String : AnyObject] = ["Status": status as AnyObject]
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Posts").childByAutoId().setValue(post)
    }
    */
    
    /// Showing the Battery Status using the slider
    ///
    /// - Parameter sender: the slider
    @IBAction func batterySlider(_ sender: UISlider) {
        let images = [UIImage(named: "greenBattery.png"), UIImage(named: "yellowBattery.png"),UIImage(named: "orangeBattery.png"),UIImage(named: "redBattery.png")]
        
        batteryLabel.text = String(Int(sender.value))
        
        if (Int(sender.value) > 75)
        {  picture.image = images[0] }
        else if (Int(sender.value) > 50)
        {  picture.image = images[1] }
        else if (Int(sender.value) > 25)
        {  picture.image = images[2] }
        else if (Int(sender.value) > 0)
        {  picture.image = images[3] }
    }
    
    @IBOutlet weak var batteryLabel: UILabel!
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBAction func track(_ sender: Any) {
    }
    
    /// Trigger the notification #1
    ///
    /// - Parameter sender: any object
    @IBAction func test1(_ sender: Any) {
        let option1 = UNNotificationAction(identifier: "option1", title: "Track it", options: UNNotificationActionOptions.foreground)

        let category = UNNotificationCategory(identifier: "myCategory", actions: [option1], intentIdentifiers: [], options: [] )
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Create a notification
        let content = UNMutableNotificationContent()
        content.title = "Alarming Condition!"
        content.body = "Your lock got outside the safe zone!"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myCategory"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        // /*Will used later */let trigger = UNLocationNotificationTrigger(triggerWithRegion:region, repeats:false)
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in })
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
    @IBAction func test2(_ sender: Any) {
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

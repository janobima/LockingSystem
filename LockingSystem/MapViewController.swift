//
//  MapViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 9/19/17.
//  Copyright © 2017 UNH. All rights reserved.
//
//
import UIKit
import UserNotifications
import Foundation
import Firebase
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    private let safeRegion = 10.0
    private let uid = Auth.auth().currentUser?.uid
    private let ref = Database.database().reference().child("Users")
    private var lockName: String?

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UNH : 41.296486, -72.961302
    ref.child(uid!).child(lockName!).observe(DataEventType.value, with: { (snapshot) in
        let post = snapshot.value as? NSDictionary
       let lat = post?["Latitude"] as? Double
        let long = post?["Longitude"] as? Double
    
        self.mapView.removeAnnotations(self.mapView.annotations)

        let initialLocation = CLLocation(latitude: 41.296486, longitude: -72.9613023)
        let currentLocation = CLLocation(latitude: lat!, longitude: long!)
        self.centerMapOnLocation(location:currentLocation)
        
        if ( self.isOutsideSafeZone(loc1: initialLocation,loc2: currentLocation) ){
            self.alarm1(AnyObject.self)
        }
        
      //  let location1 = CLLocationCoordinate2DMake(41.296486,-72.9613023)
        let location1 = CLLocationCoordinate2DMake(lat!,long!)
        let pin1 = MKPointAnnotation()
        pin1.coordinate = location1
        pin1.title = self.lockName!
        self.mapView.addAnnotation(pin1)
        })
    }
    
    /// This function calculates the distance between the current and the initial locations
    /// It checks whether the distance is larger than the safe zone 
    ///
    /// - Parameters:
    ///   - loc1: initial location
    ///   - loc2: current location
    /// - Returns: true if current location is outside the defined safe zone, false otherwise
    func isOutsideSafeZone(loc1: CLLocation, loc2: CLLocation ) -> Bool
    {
        let distance : CLLocationDistance = loc1.distance(from: loc2)/1000
        print("distance = \(distance) km")
        if (distance > self.safeRegion)
        {
            print("outside safe zone!")
            return true
        }
        print("inside safe zone!")
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// This is a setter function to set the name of the lock to send to this class.
    ///
    /// - Parameter newLock: the name of the lock that is being sent from the previous view
    func setLockName (newLock: String)
    {
        lockName = newLock
    }
    
    /// Set the center and region of the map
    ///
    /// - Parameter location: location object
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /// This function is called before segueing to the next view
    /// It will call the setter function for the next view in order
    /// to pass the data to it.
    ///
    /// - Parameters:
    ///   - segue: the type of segue
    ///   - sender: any object can trigger this function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToStatus"{
            let vc = segue.destination as! UINavigationController
            let StatusViewController = vc.topViewController as! StatusViewController
            StatusViewController.setCatchedLock(newLock: lockName!)
        }
    }
    
    /// Trigger the notification #1
    ///
    /// - Parameter sender: any object
    func alarm1(_ sender: Any) {
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
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: false)
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
    
    /// ToolBar button to navigate to the Maps app
    ///
    /// - Parameter sender: any object
    @IBAction func getDirections(_ sender: Any) {
         let location1 = CLLocationCoordinate2DMake(41.296486,-72.9613023)
        let regionSpan = MKCoordinateRegionMakeWithDistance(location1, 1000, 1000)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center ), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: location1)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "My Lock"
        mapItem.openInMaps(launchOptions: options)
    }
    
}

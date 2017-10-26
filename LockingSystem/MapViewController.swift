//
//  MapViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 9/19/17.
//  Copyright © 2017 UNH. All rights reserved.
//
//
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UNH : 41.296486, -72.961302
        let initialLocation = CLLocation(latitude: 41.296486, longitude: -72.9613023)
        centerMapOnLocation(location: initialLocation)
        
        let location1 = CLLocationCoordinate2DMake(41.296486,-72.9613023)
        let pin1 = MKPointAnnotation()
        pin1.coordinate = location1
        pin1.title = "My Lock"
        self.mapView.addAnnotation(pin1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Set the center and region of the map
    ///
    /// - Parameter location: location object
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
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

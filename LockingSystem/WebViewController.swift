//
//  WebViewController.swift
//  LockingSystem
//
//  Created by Ali Hassan AlJanobi on 10/25/17.
//  Copyright © 2017 UNH. All rights reserved.
//

import UIKit
import CoreLocation

class WebViewController: UIViewController {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var battery: UILabel!
    @IBOutlet weak var movement: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    
    struct ServerLock: Decodable{
        let id: Int
        let Status: String
        let Battery: Int
        let Movement: Bool
        let Longitude: Double//CLLocationDegrees
        let Latitude: Double//CLLocationDegrees
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        readJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func readJSON()
    {
        guard let url = URL(string:"https://raw.githubusercontent.com/janobima/LockingSystem/master/myJSON.json") else {return}
        URLSession.shared.dataTask(with: url) {(data,response,err)in
            guard let data = data else {return}
            do{
                let myServerLocks = try
                    JSONDecoder().decode([ServerLock].self, from: data)
                
                DispatchQueue.main.async {
                    self.status.text = myServerLocks[0].Status
                     self.battery.text = String(myServerLocks[0].Battery )
                     self.movement.text = String(myServerLocks[0].Movement)
                     self.longitude.text = String( myServerLocks[0].Longitude)
                     self.latitude.text = String(myServerLocks[0].Latitude)
                }
            }
            catch {
                print("Error serializing JSON")
            }
        }.resume()
        
    }
}

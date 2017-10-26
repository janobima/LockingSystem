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
    
    struct Lock{
        let status: String
        let battery: Int
        let movement: Bool
        let longitude: CLLocationDegrees
        let latitude: CLLocationDegrees
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        readJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func readJSON()
    {
        // open url
        let url = URL(string:"http://api.fixer.io/latest" )
        // open broswer to get data from url
        let task = URLSession.shared.dataTask(with: url!)
        {
            (data, response, error)in
            if error != nil
            {
                print("error!")
            }
            else
            {
                // pass data to variable content
                if let content = data
                {
                    do
                    {
                        // convert data(content) to an array
                        let myJSON = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as AnyObject
                        print(myJSON)
                        // convert it to a dictionary
                        if let rates = myJSON["rates"] as? NSDictionary
                        {
                            // index using ID and passing the data to labels
                            self.status.text = rates["AUD"]! as? String
                            self.battery.text = rates["AUD"]! as? String
                            self.movement.text = rates["AUD"]! as? String
                            self.longitude.text = rates["AUD"]! as? String
                            self.latitude.text = rates["AUD"]! as? String
    
                        }
                    }
                    catch
                    {
                        print("error")
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

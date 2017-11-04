//
//  ListViewController.swift
//  LockingSystem
//
//  Created by Maryam AlJanobi on 9/20/17.
//  Copyright © 2017 UNH. All rights reserved.
//
import UIKit
import Foundation
import CoreData
import Firebase
import FirebaseAuth

class ListViewController: UIViewController,UITableViewDelegate , UITableViewDataSource,NSFetchedResultsControllerDelegate{
    //--------------------------------------------------
    var locks: [Lock] = []
    //--------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    @IBAction func newLock(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
        print("You have logged out successfully!")
         let firebaseAuth = Auth.auth()
         do {
         try firebaseAuth.signOut()
         } catch let signOutError as NSError {
         print ("Error signing out: %@", signOutError)
         }
        performSegue(withIdentifier: "progSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        do {
            // when view loads, run the fetch (query)
            try self.fetcedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Set the number of sections in the table view
    ///
    /// - Parameter tableView: UITableView
    /// - Returns: integer which is the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Set the number of rows in the table view
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: integer
    /// - Returns: integer which is the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if let locks = fetcedResultsController.fetchedObjects {
            return locks.count
        } else {
            return 0
        }
    }
    
    /// Once CoreData is changed, update the tableview
    ///
    /// - Parameter controller: NSFetchedResultsController
    private func controllerWillChangeContent(_ controller: NSFetchedResultsController<Lock>) {
        tableView.beginUpdates()
    }
    
    /// Once the data is done updating, stop updating the table view
    ///
    /// - Parameter controller: NSFetchedResultsController
    private func controllerDidChangeContent(_ controller: NSFetchedResultsController<Lock>) {
        tableView.endUpdates()
    }
    
    /// populate the table view with core data
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: index path of the cell
    /// - Returns: table cell
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lockCell", for: indexPath)
        let lock = fetcedResultsController.object(at: indexPath)
        cell.textLabel?.text = lock.name!
        return cell
    }
    
    /// Adding the delete functionality to the table view
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - editingStyle: delete or insert
    ///   - indexPath: index path of the cell
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let context = fetcedResultsController.managedObjectContext
            let myCurrentLock = fetcedResultsController.object(at: indexPath)
            // -------------------------------------------------------------------
            // delete the data from firebase
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("Posts/"+myCurrentLock.name!).removeValue()
            // -------------------------------------------------------------------
            // Delete the data from core data
            context.delete(myCurrentLock)
            do {
                try context.save()
            } catch {
                print("Error occurred during the save")
            }
            do {
                try self.fetcedResultsController.performFetch()
            } catch {
                let fetchError = error as NSError
                print("Unable to Perform Fetch Request")
                print("\(fetchError)")
            }
            self.tableView.reloadData()

        }
    }
    
    // Fetch the data in the coredata --------------------------------
     fileprivate lazy var fetcedResultsController: NSFetchedResultsController<Lock> = {
     // Initiate the query
    let fetchRequest: NSFetchRequest<Lock> = Lock.fetchRequest()
     // Sort the data
     fetchRequest.sortDescriptors = [NSSortDescriptor(key:"name", ascending: true)]
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataContext, sectionNameKeyPath: nil, cacheName: nil)
     fetchedResultsController.delegate = self
     return fetchedResultsController
     }()
   
    /// Adding the selection functionality to the table view
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: index path of the selected cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
    /// Preparing for segue to the next view
    ///
    /// - Parameters:
    ///   - segue: name of segue
    ///   - sender: any object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatus"{
            let vc = segue.destination as! UINavigationController
            let StatusViewController = vc.topViewController as! StatusViewController
            
            if let indexpath = self.tableView.indexPathForSelectedRow
            {
                StatusViewController.setCatchedLock(newLock: fetcedResultsController.object(at: indexpath))
            }
        }
    }
    
}
extension UIViewController
{
    /// create a swipe gesture recognizer
    ///
    /// - Parameter swipe: UISwipeGestureRecognizer
    func doSwipeHome(swipe: UISwipeGestureRecognizer)
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


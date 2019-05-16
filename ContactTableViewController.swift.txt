//
//  ContactTableViewController.swift
//  MyContacts
//
//  Created by Charles Konkol on 2016-05-05
//  Copyright © 2016 Chuck Konkol. All rights reserved.
//

import UIKit
//0) Add Import Statements for CoreDate and Foundation

//**Begin Copy**
import CoreData
import Foundation
//**End Copy**

//1) Add Delegates to right of UITableViewController
//                    ,UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate
class ContactTableViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
//2) Add filter search vars
    
    //**Begin Copy**
    var filteredTableData = [NSManagedObject]()
    var resultSearchController = UISearchController()
    //**End Copy**
   
    
//3) Add UISearch func
    
    //**Begin Copy**
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredTableData.removeAll(keepCapacity: false)
        //search for field in CoreData
        let searchPredicate = NSPredicate(format: "fullname CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (contactArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [NSManagedObject]
    
        self.tableView.reloadData()
    }
    //**End Copy**
    
    
//4) Add variable to hold NSManagedObject
    
    //**Begin Copy**
    var contactArray = [NSManagedObject]()
    //**End Copy**
    
    //3) Add viewDidAppear (loads whenever view appears)
    
    //**Begin Copy**
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    //**End Copy**
    
//5) Add func loaddb to load database and refresh table
    
    //**Begin Copy**
    func loaddb()
    {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Contact")

            do {
                let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResults {
                    contactArray = results
                    tableView.reloadData()
                } else {
                    print("Could not fetch")
                }
            } catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription),\(error.userInfo)")
            }
    }
    //**End Copy**


    override func viewDidLoad() {
        super.viewDidLoad()
        
//6 Add Search Delegates 
        
    //**Begin Copy**
       self.resultSearchController.delegate = self
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.delegate = self
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
           controller.searchBar.delegate = self
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    //**End Copy**

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //7) Change to return 1
        
        //**Begin Copy**
        return 1
        //**End Copy**
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //8) Change to return contactArray.count
        
        //**Begin Copy**
        if (self.resultSearchController.active) {
            return filteredTableData.count
        }
        else {
            return contactArray.count
        }
        //**End Copy**

    }
    
  //9) Uncomment
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       //9a) Change below to load rows
        
         //**Begin Copy**
        if (self.resultSearchController.active) {
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
                as UITableViewCell!
            let person = filteredTableData[indexPath.row]
            cell.textLabel?.text = person.valueForKey("fullname") as! String?
            cell.detailTextLabel?.text = ">>"
            return cell
        }
        else {
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
                as UITableViewCell!
            let person = contactArray[indexPath.row]
            cell.textLabel?.text = person.valueForKey("fullname") as! String?
            cell.detailTextLabel?.text = ">>"
               return cell
        }
         //**End Copy**
     
    }

    //10) Add func tableView to show row clicked
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("You selected cell #\(indexPath.row)")
    }

    //9) Uncomment
    
  
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    //10) Uncomment func tableView


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //11 Change to delete swiped row
        
        if editingStyle == .Delete {
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            if (self.resultSearchController.active) {
                context.deleteObject(filteredTableData[indexPath.row])
            }
            else {
                  context.deleteObject(contactArray[indexPath.row])
            }
            
            var error: NSError? = nil
            do {
                try context.save()
                loaddb()
            } catch let error1 as NSError {
                error = error1
                print("Unresolved error \(error)")
                abort()
            }
        }
 
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  
    // MARK: - Navigation
    
   // 12) Uncomment prepareforseque

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //13) Uncomment & Change to go to proper record on proper Viewcontroller
        
        //**Begin Copy**
        if segue.identifier == "UpdateContacts" {
            if let destination = segue.destinationViewController as?
                ViewController {
                    if (self.resultSearchController.active) {
                        if let SelectIndex = tableView.indexPathForSelectedRow?.row {
                            let selectedDevice:NSManagedObject = filteredTableData[SelectIndex] as NSManagedObject
                            destination.contactdb = selectedDevice
                             resultSearchController.active = false
                        }
                    }
                    else {
                        if let SelectIndex = tableView.indexPathForSelectedRow?.row {
                            let selectedDevice:NSManagedObject = contactArray[SelectIndex] as NSManagedObject
                            destination.contactdb = selectedDevice
                        }
                    }
              }
         }
    }
       //**End Copy**

}



import UIKit
//0)


import CoreData
import Foundation


//1)
class ContactTableViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    //2)
   
    var filteredTableData = [NSManagedObject]()
    var resultSearchController = UISearchController()
      var contactArray = [NSManagedObject]()
    
//3)
  
    func updateSearchResults(for searchController: UISearchController)
    {
        filteredTableData.removeAll(keepingCapacity: false)
        //
        let searchPredicate = NSPredicate(format: "fullname CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (contactArray as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [NSManagedObject]
    
        self.tableView.reloadData()
    }
    
//4)
      override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }


//5)
    func loaddb()
    {
        
        let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Contact")

            do {
                let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResults {
                    contactArray = results
                    tableView.reloadData()
                } else {
                    print("Could not fetch")
                }
            } catch let error as NSError {
        
                print("Fetch failed: \(error.localizedDescription),\(error.userInfo)")
            }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
//6

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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {

        //7)
        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //8) Change to return contactArray.count
        
        if (self.resultSearchController.isActive) {
            return filteredTableData.count
        }
        else {
            return contactArray.count
        }

    }
    
  //9) U
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //9a)
        
        if (self.resultSearchController.isActive) {
            let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
                as UITableViewCell!
            let person = filteredTableData[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "fullname") as! String?
            cell?.detailTextLabel?.text = ">>"
            return cell!
        }
        else {
            let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
                as UITableViewCell!
            let person = contactArray[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "fullname") as! String?
            cell?.detailTextLabel?.text = ">>"
               return cell!
        }

     
    }

    //10) Add func tableView to show row clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You selected cell #\((indexPath as NSIndexPath).row)")
    }


    //9) Uncomment func
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    //10) Uncomment func
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//**Begin Copy**
        //11 Change to delete swiped row
        
        if editingStyle == .delete {
            let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            if (self.resultSearchController.isActive) {
                context.delete(filteredTableData[(indexPath as NSIndexPath).row])
            }
            else {
                  context.delete(contactArray[(indexPath as NSIndexPath).row])
            }
            
            var error: NSError? = nil
            do {
                try context.save()
                loaddb()
            } catch let error1 as NSError {
                error = error1
                print("Unresolved error \(String(describing: error))")
                abort()
            }
        }

    }

    
   // 12)

    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //
        //
        //13)
        if segue.identifier == "UpdateContacts" {
            if let destination = segue.destination as?
                ViewController {
                    if (self.resultSearchController.isActive) {
                        if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                            let selectedDevice:NSManagedObject = filteredTableData[SelectIndex] as NSManagedObject
                            destination.contactdb = selectedDevice
                             resultSearchController.isActive = false
                        }
                    }
                    else {
                        if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                            let selectedDevice:NSManagedObject = contactArray[SelectIndex] as NSManagedObject
                            destination.contactdb = selectedDevice
                        }
                    }
              }
         }
    }


}

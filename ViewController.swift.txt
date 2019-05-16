//
//  ViewController.swift
//  MyContacts
//
//  Created by Charles Konkol on 2016-05-05
//  Copyright © 2016 Chuck Konkol. All rights reserved.
//

import UIKit
//0) Add import for CoreData
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBAction func btnSave(sender: AnyObject) {
        
    //1 Add Save Logic
        
        //**Begin Copy**
        if (contactdb != nil)
        {
            
            contactdb.setValue(fullname.text, forKey: "fullname")
            contactdb.setValue(email.text, forKey: "email")
            contactdb.setValue(phone.text, forKey: "phone")
            
        }
        else
        {
            let entityDescription =
            NSEntityDescription.entityForName("Contact",inManagedObjectContext: managedObjectContext)
            
            let contact = Contact(entity: entityDescription!,
                insertIntoManagedObjectContext: managedObjectContext)
            
            contact.fullname = fullname.text!
            contact.email = email.text!
            contact.phone = phone.text!
        }
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let err = error {
            status.text = err.localizedFailureReason
        } else {
            self.dismissViewControllerAnimated(false, completion: nil)
            
        }
        //**End Copy**
    }
    
    @IBAction func btnBack(sender: AnyObject) {
    //2) Dismiss ViewController
        
        //**Begin Copy**
        self.dismissViewControllerAnimated(false, completion: nil)
        //**End Copy**
    }
    
    //3) Add ManagedObject Data Context
    
        //**Begin Copy**
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //**End Copy**
    
    //4) Add variable contactdb (used from UITableView
    
        //**Begin Copy**
    var contactdb:NSManagedObject!
        //**End Copy**
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //5 Add logic to load db. If contactdb has content that means a row was tapped on UiTableView
        
        //**Begin Copy**
        if (contactdb != nil)
        {
            fullname.text = contactdb.valueForKey("fullname") as? String
            email.text = contactdb.valueForKey("email") as? String
            phone.text = contactdb.valueForKey("phone") as? String
            btnSave.setTitle("Update", forState: UIControlState.Normal)
        }
        fullname.becomeFirstResponder()
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.DismissKeyboard))
        //Adds tap gesture to view
        view.addGestureRecognizer(tap)


        // Do any additional setup after loading the view, typically from a nib.
        
        //**End Copy**
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //6 Add to hide keyboard
    
    //**Begin Copy**
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches , withEvent:event)
        if (touches.first as UITouch!) != nil {
            DismissKeyboard()
        }
    }
    //**End Copy**
    
    //7 Add to hide keyboard
    
    //**Begin Copy**
    func DismissKeyboard(){
        //forces resign first responder and hides keyboard
        fullname.endEditing(true)
        email.endEditing(true)
        phone.endEditing(true)
        
    }
    //**End Copy**
    
    //8 Add to hide keyboard
    
    //**Begin Copy**
    func textFieldShouldReturn(textField: UITextField!) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    //**End Copy**
}


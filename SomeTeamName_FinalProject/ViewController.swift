//
//  ViewController.swift
//  SomeTeamName_FinalProject
//
//  Created by Wu, Justin on 11/16/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Actions
    @IBAction func unwindFromView(_ sender:
        UIStoryboardSegue) {}


    @IBAction func newSearchButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedContext.delete(item)
            }
            
            // Save Changes
            try managedContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        events = []
        print(events)
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        // Configure Fetch Request
        fetchRequest2.includesPropertyValues = false
        
        do {
            let items = try managedContext.fetch(fetchRequest2) as! [NSManagedObject]
            
            for item in items {
                managedContext.delete(item)
            }
            
            // Save Changes
            try managedContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        events = []
    }
}


//
//  EventTableControllerTableViewController.swift
//  SomeTeamName_FinalProject
//
//  Created by luhrkin on 11/28/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import UIKit
import CoreData
import MapKit


var selectedEvent:NSManagedObject?
var events = [NSManagedObject]()
class EventTableControllerTableViewController: UITableViewController, eventProtocol {
    
    var eventSession = eventAPI()
    //var events: [Any] = []
    
    func responseDataHandler(data: [Any]) {
        DispatchQueue.main.async {
            //self.events = data
            print("123")
            self.dataToCoreData(data: data)
            //print(self.events)
            self.tableView.reloadData()
            NotificationCenter.default.post(name: .arrayValueChanged, object: nil)
        }
    }
    
    func responseError(message: String) {
        print(message)
    }
    
    // Converting data to Core Data
    func dataToCoreData (data:[Any]){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)
        
        for i in 0...data.count-1 {
            print(i)
            let temp = data[i]
            let dict = temp as! NSDictionary
            print(dict)
            let event = NSManagedObject(entity: entity!, insertInto: managedContext)
            event.setValue(dict["cat"], forKey: "cat")
            event.setValue(dict["date"], forKey: "date")
            event.setValue(dict["description"], forKey: "eventdescription")
            event.setValue(dict["lat"], forKey: "lat")
            event.setValue(dict["long"], forKey: "long")
            event.setValue(dict["name"], forKey: "name")
            event.setValue(dict["time"], forKey: "time")
            event.setValue(dict["duration"], forKey: "duration")
            event.setValue(dict["photo"], forKey: "photo")
            event.setValue(false, forKey: "favorited")
            events.append(event)
        }
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventSession.delegate = self
        if (events.isEmpty) {
            print("GET")
            // add strings here
            // let set = getSettings()
            // let tempD = set[0].value(forKey: "duration") as! String;
            let tempD = settings!.value(forKey: "duration") as! String;
            var time = ""
            // whats a switch statement?...
            if (tempD  == "< 1 hour") {
                time = "1"
            } else if (tempD == "2 hours") {
                time = "2"
            } else if (tempD == "3 hours") {
                time = "3"
            } else if (tempD == "4 hours") {
                time = "4"
            } else {
                time = "all"
            }
            let json: [String: Any] = ["cats": settings!.value(forKey: "categories")!, "duration": time	]
            self.eventSession.parseJSON(json: json);
        } else {
            NotificationCenter.default.post(name: .arrayValueChanged, object: nil)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
   
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! eventCell
        let obj = events[indexPath.row] //as! [String: Any] // cast json to dict
        cell.title.text = obj.value(forKey: "name") as! String //obj["name"] as! String
        cell.date.text = obj.value(forKey: "date") as! String
        cell.subtitle.text = (obj.value(forKey: "duration") as! String) + " hr"
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "eventTableSegue") {
            let index = tableView.indexPathForSelectedRow?.row
            selectedEvent = events[index!] //as! [String: Any]
        }
    }
    func getSettings () -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Settings")
        var fetchedResults : [NSManagedObject]? = nil
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
            abort()
        }
        if let results = fetchedResults {
            return results
        }
        return fetchedResults!
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Notification.Name {
    static let arrayValueChanged = Notification.Name("arrayValueChanged")
}

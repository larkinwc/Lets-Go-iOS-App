//
//  StartUpViewController.swift
//  SomeTeamName_FinalProject
//
//  Created by Wu, Justin on 12/4/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import UIKit
import CoreData

var favorites = [NSManagedObject]()
class StartUpViewController: UIViewController {

    @IBOutlet weak var logoIcon: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 1.8, target: self, selector: #selector(pickFirstScene), userInfo: nil, repeats: false)
        let viewTransform = self.logoIcon.transform
        let angle = atan2f(Float(viewTransform.b), Float(viewTransform.a))
        UIView.animate(withDuration: 1.0, animations: {
            self.logoIcon.transform = CGAffineTransform(rotationAngle: CGFloat(angle + Float.pi))
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("FETCH")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Event")
        var fetchedResults : [NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
            abort()
        }
        print(fetchedResults)
        if let results = fetchedResults {
            events = results
        }
    }
    @objc func pickFirstScene() {
        print(events)
        if (events.isEmpty){
            self.performSegue(withIdentifier: "goToFirst", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "goToMain", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func radians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
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

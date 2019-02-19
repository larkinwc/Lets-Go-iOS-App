//
//  FirstTimeViewController.swift
//  SomeTeamName_FinalProject
//
//  Created by Wu, Justin on 11/30/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import UIKit
import CoreData

var settings:NSManagedObject?
var locationText:String? = nil
var durationText:String? = nil
var categoryText:String? = nil
var canSegue:Bool = false



class FirstTimeViewController: UIViewController,UITextFieldDelegate {
    
    
    // Variables
    
    
    
    // Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canSegue = false
        if (self.title! == "Location") {
            print("activate")
            locationTextField.delegate = self
            self.hideKeyboardWhenTappedAround()
        }
        if (self.title! == "First Time") {
            let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(shakeButton), userInfo: nil, repeats: true)
        }
        // Do any additional setup after loading the view.
    }
    @objc func shakeButton() {
        startButton.shake(shakeCount: 3)
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSettingsButton(_ sender: UIButton) {
        
        
        if (!selectedCats.isEmpty){
            var cat = ""
            for i in 0..<selectedCats.count-1 {
                cat += "\(selectedCats[i]), "
            }
            cat += selectedCats[selectedCats.count-1]
            addSettings(location: locationText!, duration: durationText!, category: cat)
            print("Settings: \(settings!)")
            
        }
    }
    

    @IBAction func next2Button(_ sender: UIButton) {
        if(locationTextField.hasText) {
            locationText = locationTextField.text
            canSegue = true
        }
    }

    @IBAction func findMe(_ sender: UIButton) {
        locationText = "findme"
        canSegue = true
    }
    
    
    func addSettings (location: String, duration:String, category:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Settings", in: managedContext)
        
        let setting = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        setting.setValue(location, forKey: "location")
        setting.setValue(duration, forKey: "duration")
        setting.setValue(category, forKey: "categories")
        print("Settings", setting)
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
        settings = setting
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "FirstSegue" ) {
            return canSegue
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(locationText, durationText)
        if (!selectedCats.isEmpty){
            var cat = ""
            for i in 0..<selectedCats.count-1 {
                cat += "\(selectedCats[i]), "
            }
            cat += selectedCats[selectedCats.count-1]
            addSettings(location: locationText!, duration: durationText!, category: cat)
            print("Settings: \(settings!)")
            
        }
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
//Used for dissmissing on tap other places
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
//Adds a shake animation function
extension UIView {
    func shake(duration: TimeInterval = 0.05, shakeCount: Float = 6, xValue: CGFloat = 12, yValue: CGFloat = 0){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = shakeCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - xValue, y: self.center.y - yValue))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + xValue, y: self.center.y - yValue))
        self.layer.add(animation, forKey: "shake")
    }
    
}

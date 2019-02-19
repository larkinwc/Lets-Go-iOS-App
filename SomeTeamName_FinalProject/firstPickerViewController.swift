//
//  firstPickerViewController.swift
//  SomeTeamName_FinalProject
//
//  Created by Williams-Capone, Larkin on 11/30/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import UIKit

class firstPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Variables
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    var canSegue:Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        
        pickerOptions = ["< 1 hour", "2 hours", "3 hours", "4 hours", "all"]
        
        durationText = pickerOptions[0]

        // Do any additional setup after loading the view.
    }

    @IBAction func firstButton(_ sender: Any) {
        if (durationText != nil) {
            canSegue = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var pickerOptions: [String] = [String]()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerOptions[row]
//    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerOptions[row], attributes:[.foregroundColor: UIColor(red:0.96, green:0.83, blue:0.71, alpha:1.0)])
        return attributedString
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        durationText = pickerOptions[row]
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "FirstSegue" ) {
            return canSegue
        }
        return true
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

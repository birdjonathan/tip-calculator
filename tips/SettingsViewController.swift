//
//  SettingsViewController.swift
//  tips
//
//  Created by dev on 1/12/16.
//  Copyright © 2016 birdjonathan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipPercentageField: UITextField!
    
    @IBOutlet weak var Magic: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        let myNumber = defaults.integerForKey("defaultTip")
        print(myNumber)
        tipPercentageField.text = "\(myNumber)%"
        tipPercentageField.clearsOnBeginEditing = true
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MagicRecall(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let myNumber = defaults.integerForKey("defaultTip")
        print(myNumber)
    }
    
    @IBAction func DismissSettingsModal(sender: AnyObject) {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func OnEditingChanged(sender: AnyObject) {
        let defaultTipPercentage = NSString(string: tipPercentageField.text!).integerValue
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(defaultTipPercentage, forKey: "defaultTip")
        
        defaults.synchronize()
        
        
        //tipPercentageField.text = "%\(defaultTipPercentage)"
//        let tip = billAmount * tipPercentage
//        let total = billAmount + tip
//        tipLabel.text = "$\(tip)"
//        totalLabel.text = "$\(total)"
//        
//        tipLabel.text = String(format: "$%.2f", tip)
//        totalLabel.text = String(format: "$%.2f", total)
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

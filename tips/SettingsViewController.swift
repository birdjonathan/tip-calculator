//
//  SettingsViewController.swift
//  tips
//
//  Created by dev on 1/12/16.
//  Copyright © 2016 Jonathan Bird. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipPercentageField: UITextField!
    @IBOutlet weak var salesTaxField: UITextField!
    @IBOutlet weak var Magic: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipNumber = defaults.integerForKey("defaultTip")
        let salesNumber = defaults.integerForKey("defaultSalesTax")
        tipPercentageField.text = "\(tipNumber)%"
        tipPercentageField.clearsOnBeginEditing = true
        salesTaxField.text = "\(salesNumber)%"
        salesTaxField.clearsOnBeginEditing = true

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.5, delay: 0.4, options: [.CurveEaseOut, .Autoreverse], animations: {
            self.view.backgroundColor = UIColor.cyanColor()
        }, completion: nil )
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func DismissSettingsModal(sender: AnyObject) {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func OnEditingChanged(sender: AnyObject) {
        let defaultTipPercentage = NSString(string: tipPercentageField.text!).integerValue
        let defaultSalesTaxRate = NSString(string: salesTaxField.text!).integerValue
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Sets
        defaults.setInteger(defaultTipPercentage, forKey: "defaultTip")
        defaults.setInteger(defaultSalesTaxRate, forKey: "defaultSalesTax")
        defaults.synchronize()
        
    }
    
    // Closes modals on tap
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

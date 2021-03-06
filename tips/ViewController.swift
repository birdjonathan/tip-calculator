//
//  ViewController.swift
//  tips
//
//  Created by dev on 1/11/16.
//  Copyright © 2016 Jonathan Bird. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberOfPayersControl: UIStepper!
    @IBOutlet weak var numberOfPayersLabel: UILabel!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    //************************************************
    // Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        billField.text = "Enter amount"
       
        // Some default setting for the number of payees control
        numberOfPayersLabel.text = "1"
        numberOfPayersControl.wraps = true
        numberOfPayersControl.autorepeat = true
        numberOfPayersControl.maximumValue = 99
        numberOfPayersControl.minimumValue = 1
        
        // Only start tracking the initial moment if we have not stored a start time
        if defaults.objectForKey("startMoment") == nil {
            setStartMoment()
            print("set first start moment")
        }
        // Pop up keyboard automatically
        self.billField.becomeFirstResponder()
        billField.clearsOnBeginEditing = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Tip Calculator"
        super.viewWillAppear(animated)
                self.view.backgroundColor = UIColor.cyanColor()
        setInitialTipAndTax()
        // The following code will reset the calculator if ten minutes have passed
        let timeUsingApp = timeElapsed()
        if timeUsingApp < -600 {
            print("Reset to 0", timeElapsed(), " seconds have passed")
            billField.text = "0"
            setBillAmount()
            updateTipCalculator()
            setStartMoment()
        } else {
            print("Do not reset not enough time yet", timeUsingApp)
            updateBillAmount()
            updateTipCalculator()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        billField.center.x -= view.bounds.width
        totalLabel.center.x -= view.bounds.width
        UIView.animateWithDuration(0.5, animations: {
            self.view.backgroundColor = UIColor.whiteColor()
            self.billField.center.x += self.view.bounds.width
        })
        
        UIView.animateWithDuration(0.5, delay: 0.2, options: [], animations:{
            self.totalLabel.center.x += self.view.bounds.width
            }, completion:nil)
        
        self.billField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("Will disappear")
        setBillAmount()
        //setStartMoment()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("Did disappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //***************************************************
    // Actions
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        updateTipCalculator()
    }
    
    @IBAction func ChangeTipPercentage(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipPercentages = [18, 20, 22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        defaults.setInteger(tipPercentage, forKey: "defaultTip")
        defaults.synchronize()
        
        updateTipCalculator()
        self.billField.becomeFirstResponder()

    }
    
    @IBAction func changeNumberPayers(sender: AnyObject) {
        let totalNumberOfPayers = Double(numberOfPayersControl.value)
        numberOfPayersLabel.text = "\(Int(numberOfPayersControl.value))"
        let tipAmount = String(tipLabel.text!).characters.dropFirst()
        let newTipStr = String(tipAmount)
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let tipAmountDouble = numberFormatter.numberFromString(newTipStr)?.doubleValue
        let tipSplit = tipAmountDouble! / totalNumberOfPayers
        numberFormatter.numberStyle = .CurrencyStyle
        let tipStr = numberFormatter.stringFromNumber(tipSplit)!
        splitLabel.text = "\(tipStr)"
    }
    
    @IBAction func onTap(sender: AnyObject) {
        
        view.endEditing(true)
    }
    
    //***********************************************************
    //Helper Functions
    
    func setStartMoment () {
        let currentTime = NSDate()
        defaults.setObject(currentTime, forKey: "startMoment")
        defaults.synchronize()
    }
    
    func timeElapsed () -> Int{
        let startMoment = defaults.objectForKey("startMoment")
        let now = NSDate()
        let elapsed = startMoment?.timeIntervalSinceDate(now)
        print("Elapsed time", Int(elapsed!))
        return Int(elapsed!)
    }
    
    func setBillAmount () {
        let defaults = NSUserDefaults.standardUserDefaults()
        let billAmount = NSString(string: billField.text!).doubleValue
        defaults.setDouble(billAmount, forKey: "billAmount")
        defaults.synchronize()
    }
    
    func updateBillAmount () {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        billField.text = defaults.stringForKey("billAmount")
    }
    
    func setInitialTipAndTax () {
        if defaults.objectForKey("defaultTip") == nil {
            defaults.setInteger(18, forKey: "defaultTip")
            defaults.setInteger(9, forKey: "defaultSalesTax")
            defaults.synchronize()
        }
    }
    
    func updateTipCalculator (){
        
        // Grabs default values from memory
        let defaults = NSUserDefaults.standardUserDefaults()
        let initialTipInt = defaults.integerForKey("defaultTip")
        print(initialTipInt)
        let initialTipPercentage = Double(initialTipInt)/100
        let initialSalesTaxInt = defaults.integerForKey("defaultSalesTax")
        let initialSalesTaxRate = Double(initialSalesTaxInt)/100
        // Gets number of people to split the tip among from UI label
        let numberOfPayers = NSString(string: numberOfPayersLabel.text!).doubleValue
        let billAmount =  NSString(string: billField.text!).doubleValue
        let tax = billAmount * initialSalesTaxRate
        let checkTotal = billAmount + tax
        let tip = checkTotal * initialTipPercentage
        let finalTotal = checkTotal + tip
        let splitAmount = tip / numberOfPayers
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        let finalTotalStr = numberFormatter.stringFromNumber(finalTotal)!
        let splitAmountStr = numberFormatter.stringFromNumber(splitAmount)!
        let taxStr = numberFormatter.stringFromNumber(tax)!
        let tipStr = numberFormatter.stringFromNumber(tip)!
        // Sets the correct value for all the labels
        tipLabel.text = "\(tipStr)"
        totalLabel.text = "\(finalTotalStr)"
        splitLabel.text = "\(splitAmountStr)"
        taxLabel.text = "\(taxStr)"
        //Save the bill amount to memory
        setBillAmount()
        
    }

}


//
//  AddItemViewController.swift
//  DZD
//
//  Created by 竹田 on 2015/8/18.
//  Copyright (c) 2015年 ChuroCat. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func add(sender: UIButton) {
        if let weight = weightTextField.text  {
            var weightDouble = (weight as NSString).doubleValue
            DZDRequest.insertWeight(weightDouble, unit: DZDWeightUnit.Kg, uid: DzdDefault.User, date: datePicker.date)
        }
    }
}

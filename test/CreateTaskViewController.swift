//
//  CreateTaskViewController.swift
//  test
//
//  Created by Admin on 21.04.17.
//  Copyright © 2017 garon. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskViewController: BaseViewController {
    
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextView!

    
    
    //MARK: Actions
    @IBAction func createTaskButton(_ sender: UIButton) {
        
        
        
        if((nameTextField.text?.isEmpty)! || (timeTextField.text?.isEmpty)! || (startDateTextField.text?.isEmpty)! || (endDateTextField.text?.isEmpty)!){
            
            createAlert(status: EMPTY_CHECK)
            
        } else {
            
            if(dateComparator()) {
                
                saveTask(name: nameTextField.text!, percentCompletition: 0, state: .New, estimatedTime: Int32(timeTextField.text!)!, startDate: startDate, dueDate: endDate, description: taskDescriptionTextField.text)
                navigationController?.popViewController(animated: true)
            } else {
                
                createAlert(status: DATE_CHECK)
            }        
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var textFields = [UITextField]()
        textFields.append(nameTextField)
        textFields.append(timeTextField)
        textFields.append(startDateTextField)
        textFields.append(endDateTextField)
        
        textFieldsStyles(textFieldArray: textFields, taskDescription: taskDescriptionTextField)
        createStartDatePicker()
        createEndDatePicker()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createStartDatePicker() {
        
        startDatePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneStartPressed))
        toolbar.setItems([doneButton], animated: true)

        startDateTextField.inputAccessoryView = toolbar
        startDateTextField.inputView = startDatePicker
        
    }
    
    func doneStartPressed(){
        
        dateFormatter.setPreferences()
        
        startDateTextField.text = dateFormatter.string(from: startDatePicker.date)
        startDate = startDatePicker.date
        self.view.endEditing(true)
    }
    
    func createEndDatePicker() {
        
        endDatePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneEndPressed))
        toolbar.setItems([doneButton], animated: true)
        
        endDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputView = endDatePicker
    }
    
    func doneEndPressed(){
        
        dateFormatter.setPreferences()
        
        endDateTextField.text = dateFormatter.string(from: endDatePicker.date)
        endDate = endDatePicker.date
        self.view.endEditing(true)
    }
    
    
        
}
    




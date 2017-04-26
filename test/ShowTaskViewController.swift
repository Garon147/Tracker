//
//  ViewController.swift
//  test
//
//  Created by Admin on 21.04.17.
//  Copyright © 2017 garon. All rights reserved.
//

import UIKit
import CoreData

class ShowTaskViewController: BaseViewController {
    
    
    var indexPath: IndexPath? = nil
    var textFields = [UITextField]()
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var progressTextField: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var taskDescriptionText: UITextView!
    @IBOutlet weak var applyChangesBtn: UIButton!
    @IBOutlet weak var switchButton: UISwitch!
    
    
    
    //MARK: Actions
    @IBAction func applyChangesButton(_ sender: UIButton) {
        
        
        if ((nameTextField.text?.isEmpty)! || (progressTextField.text?.isEmpty)! || (timeTextField.text?.isEmpty)! ) {
            
            let alertTitle = "Error"
            let alertMessage = "All fields except description must be filled!"
            
            let alert = UIAlertController(title: alertTitle, message: alertMessage,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            
            alert.addAction(okAction)
            present(alert, animated: true)
            
            

        } else {
            
            saveTask(name: nameTextField.text!, percentCompletition: Int16(progressTextField.text!)!, state: .InProgress, estimatedTime: Int32(timeTextField.text!)!, startDate: startDate, dueDate: endDate, description: taskDescriptionText.text)
            
            switchButton.isOn = false
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func editSwitchButton(_ sender: UISwitch) {
        
        if (sender.isOn) {
            
            for item in textFields {
                item.isEnabled = true
            }
            
            taskDescriptionText.isEditable = true
            applyChangesBtn.isEnabled = true
        } else {
            
            for item in textFields {
                item.isEnabled = false
            }
            
            taskDescriptionText.isEditable = false
            applyChangesBtn.isEnabled = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textFields.append(nameTextField)
        textFields.append(progressTextField)
        textFields.append(statusTextField)
        textFields.append(timeTextField)
        textFields.append(startDateTextField)
        textFields.append(endDateTextField)
        
        textFieldsStyles(textFieldArray: textFields, taskDescription: taskDescriptionText)
        setEdits(textFields: textFields, textDescription: taskDescriptionText)
        
        fetchData(taskTable: nil)
        let task = tasks[(indexPath?.row)!]
        setText(task: task as! Task)
        createStartDatePicker()
        createEndDatePicker()
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setText(task: Task) {
        
        let progress = task.value(forKey: "percentCompletition")
        
        progressView.setProgress(progress as! Float, animated: true)
        
        nameTextField.text = task.value(forKey: "name") as? String
        progressTextField.text = String(describing: progress!)
        statusTextField.text = task.value(forKey: "state") as? String
        timeTextField.text = String(describing: task.value(forKey: "estimatedTime")!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        startDateTextField.text = dateFormatter.string(from: task.value(forKey: "startDate") as! Date)
        endDateTextField.text = dateFormatter.string(from: task.value(forKey: "endDate") as! Date)
        taskDescriptionText.text = task.value(forKey: "taskDescription") as? String
    }
    
    func setEdits(textFields: [UITextField], textDescription: UITextView) {
            
        for item in textFields {
            item.isEnabled = false
        }
            
        textDescription.isEditable = false
        
        applyChangesBtn.isEnabled = false

    }
    
    override func saveTask(name: String, percentCompletition: Int16, state: State, estimatedTime: Int32, startDate: Date, dueDate: Date, description: String?) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        tasks[(indexPath?.row)!].setValue(count, forKey: "id")
        tasks[(indexPath?.row)!].setValue(name, forKey: "name")
        tasks[(indexPath?.row)!].setValue(percentCompletition, forKey: "percentCompletition")
        tasks[(indexPath?.row)!].setValue(state.rawValue, forKey: "state")
        tasks[(indexPath?.row)!].setValue(estimatedTime, forKey: "estimatedTime")
        tasks[(indexPath?.row)!].setValue(startDate, forKey: "startDate")
        tasks[(indexPath?.row)!].setValue(dueDate, forKey: "endDate")
        tasks[(indexPath?.row)!].setValue(description, forKey: "taskDescription")
        
        do {
            try managedContext.save()
            print("edit succeeded, \(tasks.count)")
        } catch let error as NSError {
            print("could not save, \(error), \(error.userInfo)")
        }
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


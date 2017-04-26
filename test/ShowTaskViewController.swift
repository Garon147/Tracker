//
//  ViewController.swift
//  test
//
//  Created by Admin on 21.04.17.
//  Copyright © 2017 garon. All rights reserved.
//

import UIKit
import CoreData

class ShowTaskViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Properties
    var indexPath: IndexPath? = nil
    var textFields = [UITextField]()
    var oldProgress: Int16 = 0
    var newProgress: Int16 = 0
    let picker = UIPickerView()
    let pickerStateArray = [State.New.rawValue, State.InProgress.rawValue, State.Done.rawValue]
    
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
            
            createAlert(status: EMPTY_CHECK)
            

        } else {
            
            newProgress = Int16(progressTextField.text!)!
            
            if(dateComparator()){
                
                if(checkProgress()){
                    
                    if(checkProgressValue()) {
                        saveTask(name: nameTextField.text!, percentCompletition: newProgress, state: State(rawValue: statusTextField.text!)!, estimatedTime: Int32(timeTextField.text!)!, startDate: startDate, dueDate: endDate, description: taskDescriptionText.text)
                        
                        switchButton.isOn = false
                        navigationController?.popViewController(animated: true)
                    } else {
                        createAlert(status: PROGRESS_VALUE_CHECK)
                    }
                } else {
                    createAlert(status: PROGRESS_CHECK)
                }
            } else {
                createAlert(status: DATE_CHECK)
            }
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
        
        picker.delegate = self
        picker.dataSource = self
        statusTextField.inputView = picker
        
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
        applyChangesBtn.setPreferences()
    }
    
    //MARK: setting UI
    func setText(task: Task) {
        
        let progress = Int16(task.value(forKey: "percentCompletition") as! Int16)
        oldProgress = progress
        let progressPercent = Float(progress)/100
        
        progressView.setProgress(progressPercent , animated: true)
        
        nameTextField.text = task.value(forKey: "name") as? String
        progressTextField.text = String(describing: progress)
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
    
    //MARK: database methods
    override func saveTask(name: String, percentCompletition: Int16, state: State, estimatedTime: Int32, startDate: Date, dueDate: Date, description: String?) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
    
    //MARK: Date Pickers
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
    
    func checkProgress() -> Bool {
        if(oldProgress < newProgress || oldProgress == newProgress) {
            return true
        } else {
            return false
        }
    }
    
    func checkProgressValue() -> Bool {
        if(newProgress < 100 || newProgress == 100) {
            return true
        } else {
            return false
        }
    }
    
    //MARK: StatePicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerStateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerStateArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusTextField.text = pickerStateArray[row]
        self.view.endEditing(false)
    }

}


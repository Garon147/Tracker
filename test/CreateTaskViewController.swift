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
    

    //MARK: Properties
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var startDate = Date()
    var endDate = Date()
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextView!

    
    
    //MARK: Actions
    @IBAction func createTaskButton(_ sender: UIButton) {
        
        let alertTitle = "Error"
        let alertMessage = "All field except description must be filled!"
        
        if((nameTextField.text?.isEmpty)! || (timeTextField.text?.isEmpty)! || (startDateTextField.text?.isEmpty)! || (endDateTextField.text?.isEmpty)!){
            
            let alert = UIAlertController(title: alertTitle, message: alertMessage,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            
            alert.addAction(okAction)
            present(alert, animated: true)
            
        } else {
        
            saveTask(name: nameTextField.text!, percentCompletition: 0, state: .New, estimatedTime: Double(timeTextField.text!)!, startDate: startDate, dueDate: endDate, description: taskDescriptionTextField.text)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldsStyles()
        createStartDatePicker()
        createEndDatePicker()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldsStyles() {
        
        taskDescriptionTextField.layer.borderWidth = 1
        taskDescriptionTextField.layer.borderColor = UIColor.black.cgColor
        
        var textFields = [UITextField]()
        textFields.append(nameTextField)
        textFields.append(timeTextField)
        textFields.append(startDateTextField)
        textFields.append(endDateTextField)
        
        for item in textFields{
            item.setBorderStyle()
        }
        
    }
    
    func saveTask(name: String, percentCompletition: Int16, state: State, estimatedTime: Double, startDate: Date,
                  dueDate: Date, description: String?) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(name, forKey: "name")
        task.setValue(percentCompletition, forKey: "percentCompletition")
        task.setValue(state.rawValue, forKey: "state")
        task.setValue(estimatedTime, forKey: "estimatedTime")
        task.setValue(startDate, forKey: "startDate")
        task.setValue(dueDate, forKey: "endDate")
        task.setValue(description, forKey: "taskDescription")
        
        do {
            try managedContext.save()
            tasks.append(task)
            print("save succeeded, \(tasks.count)")
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        endDateTextField.text = dateFormatter.string(from: endDatePicker.date)
        endDate = endDatePicker.date
        self.view.endEditing(true)
    }
    
    
    
    
//    @nonobjc func checkDateText(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
//                       replacementString string: String)->Bool {
//        
//        if (textField.tag == 1 || textField.tag == 2) {
//            
//            let numbersOnly = NSCharacterSet(charactersIn: "123456789-")
//            let characterSetFromTextField = NSCharacterSet(charactersIn: string)
//            
//            let Validate:Bool = numbersOnly .isSuperset(of: characterSetFromTextField as CharacterSet)
//            if (!Validate) {
//                return false;
//            }
//            if (range.length + range.location > (textField.text?.characters.count)!) {
//                return false
//            }
//            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
//            if newLength == 3 || newLength == 6 {
//                let  char = string.cString(using: String.Encoding.utf8)!
//                let isBackSpace = strcmp(char, "\\b")
//                
//                if (isBackSpace == -92) {
//                    dateFormate = false;
//                }else{
//                    dateFormate = true;
//                }
//                
//                if dateFormate {
//                    let textContent:String!
//                    textContent = textField.text
//                    //3.Here we add '-' on overself.
//                    let textWithHifen:NSString = "\(textContent)-" as NSString
//                    textField.text = textWithHifen as String
//                    dateFormate = false
//                }
//            }
//            //4. this one helps to make sure only 8 character is added in textfield .(ie: dd-mm-yy)
//            return newLength <= 10;
//            
//        }
//        return true
//    }
    
        
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



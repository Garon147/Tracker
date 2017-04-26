//
//  BaseViewController.swift
//  test
//
//  Created by Admin on 24.04.17.
//  Copyright © 2017 garon. All rights reserved.
//

import UIKit
import CoreData

class BaseViewController: UIViewController {
    
    let CREATE_TASK_ID = "CreateTask"
    let SHOW_TASK_ID = "ShowTask"
    
    let EMPTY_CHECK = "emptyCheck"
    let DATE_CHECK = "dateCheck"
    let PROGRESS_CHECK = "progressCheck"
    let PROGRESS_VALUE_CHECK = "progressValueCheck"
    
    public var tasks = [NSManagedObject]();
    var count: Int16 = 0
    let dateFormatter = DateFormatter()
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var startDate = Date()
    var endDate = Date()
    
    let alertTitle = "Error"
    let alertMessage = "All fields except description must be filled!"
    let dateAlertMessage = "Start date must be less than end date"
    let progressAlertMessage = "New progress value must be bigger than previous"
    let progressValueMessage = "Progress value can't be bigger than 100"
    let okAction = UIAlertAction(title: "OK", style: .default)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveTask(name: String, percentCompletition: Int16, state: State, estimatedTime: Int32, startDate: Date,
                  dueDate: Date, description: String?) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
        task.setValue(count, forKey: "id")
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
            count += 1
            print("save succeeded, \(tasks.count)")
        } catch let error as NSError {
            print("could not save, \(error), \(error.userInfo)")
        }
        
    }
    
    func textFieldsStyles(textFieldArray: [UITextField], taskDescription: UITextView) {
        
        taskDescription.layer.borderWidth = 1
        taskDescription.layer.borderColor = UIColor.black.cgColor
    
        for item in textFieldArray{
            item.setBorderStyle()
        }
        
    }
    
    func fetchData(taskTable: UITableView?) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
            if(taskTable != nil){
                taskTable?.reloadData()
            }
            
            print("fetch succeeded")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    func dateComparator() -> Bool {
        
        if(startDate < endDate || startDate == endDate) {
            return true
        } else {
            return false
        }
    }
    
    func createAlert(status: String) {
        
        var alert = UIAlertController()
        
        switch status {
        case EMPTY_CHECK:
            alert = UIAlertController(title: alertTitle, message: alertMessage,
                                      preferredStyle: .alert)
            break
        case DATE_CHECK:
            alert = UIAlertController(title: alertTitle, message: dateAlertMessage,
                                      preferredStyle: .alert)
            break
        case PROGRESS_CHECK:
            alert = UIAlertController(title: alertTitle, message: progressAlertMessage, preferredStyle: .alert)
            break
        case PROGRESS_VALUE_CHECK:
            alert = UIAlertController(title: alertTitle, message: progressValueMessage, preferredStyle: .alert)
            break
        default:
            break
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
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

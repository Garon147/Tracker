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
//    var task: NSManagedObject? = nil
    
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
        
        switchButton.isOn = false
    }
    
    @IBAction func editSwitchButton(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var textFields = [UITextField]()
        textFields.append(nameTextField)
        textFields.append(progressTextField)
        textFields.append(statusTextField)
        textFields.append(timeTextField)
        textFields.append(startDateTextField)
        textFields.append(endDateTextField)
        textFieldsStyles(textFieldArray: textFields, taskDescription: taskDescriptionText)
        
        fetchData()
        let task = tasks[(indexPath?.row)!]
        
        print("\(tasks.count)")
        
        nameTextField.text = task.value(forKey: "name") as? String
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func fetchData() {
        
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
            print("fetch succeeded")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }


}


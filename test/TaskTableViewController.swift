//
//  TaskTableViewController.swift
//  test
//
//  Created by Admin on 21.04.17.
//  Copyright © 2017 garon. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var taskTable: UITableView!
    
    
    
    //MARK: Actions

    @IBAction func newTaskButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "CreateTask", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTable.dataSource = self
        taskTable.delegate = self
        
        taskTable.tableFooterView = UIView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            taskTable.reloadData()
            print("fetch succeeded")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasks[indexPath.row]
        let cell = taskTable.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        
        
        cell.nameLabel.text = task.value(forKey: "name") as? String
        cell.descriptionLabel.text = task.value(forKey: "taskDescription") as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        
        let startDateString = dateFormatter.string(from: task.value(forKey: "startDate") as! Date)
        let endDateString = dateFormatter.string(from: task.value(forKey: "endDate") as! Date)
        
        cell.datesLabel.text = startDateString + " - " + endDateString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }


    


}



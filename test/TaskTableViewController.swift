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
    
    //MARK: Outlets
    @IBOutlet weak var taskTable: UITableView!
    
    
    
    //MARK: Actions
    @IBAction func createNewTaskButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: CREATE_TASK_ID, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTable.dataSource = self
        taskTable.delegate = self
        
        taskTable.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData(taskTable: taskTable)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: SHOW_TASK_ID, sender: tasks[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SHOW_TASK_ID,
           let nextScene = segue.destination as? ShowTaskViewController,
            let indexPath = self.taskTable.indexPathForSelectedRow {
            
            nextScene.indexPath = indexPath
        }
    }
    

}



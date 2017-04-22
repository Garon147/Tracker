//
//  TaskTableViewController.swift
//  test
//
//  Created by Admin on 21.04.17.
//  Copyright © 2017 garon. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var taskTable: UITableView!
    
    
    var tasks = [Task]();
    
    
    //MARK: Actions
    
    @IBAction func createTaskButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "CreateTask", sender: self)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    


}



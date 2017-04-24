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
    
    var tasks = [NSManagedObject]();
    var tableMustBeUpdated = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

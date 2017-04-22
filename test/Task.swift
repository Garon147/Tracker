//
//  Task.swift
//  test
//
//  Created by Admin on 21.04.17.
//  Copyright © 2017 garon. All rights reserved.
//

import Foundation

class Task1 {
    
    //MARK: Properties
    
    var name: String
    var percentCompletition: Int
    var state: State
    var estimatedTime: Double
    var startDate: Date
    var dueDate: Date
    var description: String?
    
    //MARK: Initialization
    
    init?(name: String, percentCompletition: Int, state: State, estimatedTime: Double, startDate: Date,
         dueDate: Date, description: String) {
        
        if (name.isEmpty || percentCompletition < 0 || estimatedTime < 0){
            return nil
        }
        
        self.name = name
        self.percentCompletition = percentCompletition
        self.state = state
        self.estimatedTime = estimatedTime
        self.startDate = startDate
        self.dueDate = dueDate
        self.description = description
    }
}

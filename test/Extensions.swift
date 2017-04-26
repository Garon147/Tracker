//
//  Extensions.swift
//  test
//
//  Created by Admin on 22.04.17.
//  Copyright © 2017 garon. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setBorderStyle() {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
}

extension DateFormatter {
    
    func setPreferences() {
        
        self.dateStyle = .short
        self.timeStyle = .none
    }
}

//
//  StudentManager.swift
//  OnTheMap
//
//  Created by André Servidoni on 10/11/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

// Singleton class responsible to hold the list of 
// StudentLocation get from Parser service
class StudentManager {
    
    var studentArray: [StudentLocation] = []
    
    class func sharedInstance() -> StudentManager {
        
        struct Singleton {
            static var sharedInstance = StudentManager()
        }
        
        return Singleton.sharedInstance
    }
    
    // clean the student list when refresh
    func clean() {
        studentArray.removeAll()
    }
}
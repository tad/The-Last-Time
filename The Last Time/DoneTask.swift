//
//  DoneTask.swift
//  The Last Time
//
//  Created by Tad Donaghe on 4/22/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import UIKit

class DoneTask: NSObject, NSCoding {
  var dateCompleted: Date
  var taskName: String
  
  init(taskName: String, dateCompleted: Date) {
    self.taskName = taskName
    self.dateCompleted = dateCompleted
    
    super.init()
  }

  convenience init(_ taskName: String) {
    self.init(taskName: taskName, dateCompleted: Date())
  }
  
  required init?(coder aDecoder: NSCoder) {
    dateCompleted = aDecoder.decodeObject(forKey: "dateCompleted") as! Date
    taskName = aDecoder.decodeObject(forKey: "taskName") as! String
    
    super.init()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(dateCompleted, forKey: "dateCompleted")
    aCoder.encode(taskName, forKey: "taskName")
  }
}

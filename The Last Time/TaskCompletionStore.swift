//
//  File.swift
//  The Last Time
//
//  Created by Tad Donaghe on 5/11/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import Foundation
import CoreData

class TaskCompletionStore {
  
  var taskCompletions = [TaskCompletion]()
  var fetchRequest: NSFetchRequest<Task>!
  
  let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "TheLastTime")
    container.loadPersistentStores { (decription, error) in
      if let error = error {
        print("Error setting up Core Data (\(error)).")
      }
    }
    return container
  }()
  
  init() {
    taskCompletions = getTaskCompletions()
  }
  
    
  func addTaskCompletion(name: String, completionDate: Date) {
    let completion = Completion(context: persistentContainer.viewContext)
    completion.date = completionDate as NSDate
    let task = Task(context: persistentContainer.viewContext)
    task.name = name
    task.addToCompletions(completion)
    do {
      try persistentContainer.viewContext.save()
      taskCompletions.append(TaskCompletion(date: completionDate, name: name))
    } catch let error as NSError {
      print("Save failed: \(error), \(error.userInfo)")
    }
  }    
  
  func getTaskCompletions() -> [TaskCompletion] {
    var taskCompletions = [TaskCompletion]()
    fetchRequest = Task.fetchRequest()
    do {
      let tasks = try persistentContainer.viewContext.fetch(fetchRequest)
      
      for task in tasks {
        if let mostRecentCompletion = task.completions?.firstObject as? Completion {
          let taskCompletion = TaskCompletion(date: mostRecentCompletion.date! as Date, name: task.name!)
          taskCompletions.append(taskCompletion)
        }
      }
    } catch let error as NSError {
      print("Fetch failed: \(error), \(error.userInfo)")
    }
    
    return taskCompletions
  }
  
}

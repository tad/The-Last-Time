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
    refresh()
  }
  
  func refresh() {
    taskCompletions = getTaskCompletions()
  }
  
  
  func addTaskCompletion(name: String, completionDate: Date?) {
    let completion = Completion(context: persistentContainer.viewContext)
    let task = Task(context: persistentContainer.viewContext)
    task.name = name
    if (completionDate != nil) {
      completion.date = completionDate! as NSDate
      task.addToCompletions(completion)
    }
    do {
      try persistentContainer.viewContext.save()
      taskCompletions.append(TaskCompletion(date: completionDate, name: name, totalCompletes: 1))
    } catch let error as NSError {
      print("Save failed: \(error), \(error.userInfo)")
    }
  }
  
  func addNewCompletion(forTask: Task) {
    let completion = Completion(context: persistentContainer.viewContext)
    completion.date = NSDate()
    forTask.addToCompletions(completion)
    
    // Save the managed object context
    do {
      try persistentContainer.viewContext.save()
    } catch let error as NSError {
      print("Save error: \(error), description:\(error.userInfo)")
    }
  }
  
  func deleteCompletion(forTask: Task, completion: Completion) {
    forTask.removeFromCompletions(completion)
    do {
      try persistentContainer.viewContext.save()
      refresh()
    } catch let error as NSError {
      print("Save error: \(error), description:\(error.userInfo)")
    }
  }
  
  func deleteTask(_ task:Task) {
    persistentContainer.viewContext.delete(task)
    do {
      try persistentContainer.viewContext.save()
    } catch let error as NSError {
      print("Delete failed: \(error), \(error.userInfo)")
    }
    self.refresh()
  }
      
  func getTask(_ taskName: String) -> Task {
    
    var returnTask: Task?
    
    let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
    let taskFetchPredicate = NSPredicate(format: "%K == %@", #keyPath(Task.name), taskName)
    fetchRequest.predicate = taskFetchPredicate
    
    do {
       returnTask = try persistentContainer.viewContext.fetch(fetchRequest).first!
    } catch let error as NSError {
      print("Fetch failed: \(error), \(error.userInfo)")
    }        
    
    return returnTask!
  }
  
  func getTaskCompletions() -> [TaskCompletion] {
    var taskCompletions = [TaskCompletion]()
    fetchRequest = Task.fetchRequest()
    do {
      let tasks = try persistentContainer.viewContext.fetch(fetchRequest)
      
      for task in tasks {
        if let mostRecentCompletion = task.completions?.lastObject as? Completion {
          let taskCompletion = TaskCompletion(date: mostRecentCompletion.date! as Date, name: task.name!, totalCompletes: (task.completions?.count)!)
          taskCompletions.append(taskCompletion)
        } else {
          let taskCompletion = TaskCompletion(date: nil, name: task.name!, totalCompletes: 0)
          taskCompletions.append(taskCompletion)
        }
      }
    } catch let error as NSError {
      print("Fetch failed: \(error), \(error.userInfo)")
    }
    
    // Sort array so most recently completed tasks are first
    taskCompletions = taskCompletions.sorted(by: { $0.date != nil && $0.date! > $1.date!})
    
    return taskCompletions
  }
  
}

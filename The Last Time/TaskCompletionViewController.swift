//
//  DoneTasksViewController.swift
//  The Last Time
//
//  Created by Tad Donaghe on 4/22/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import UIKit

class TaskCompletionViewController: UITableViewController {
  var taskCompletionStore: TaskCompletionStore!
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
  }()
  
  
  var dateDifference = DateDifference()
  
  @IBAction func addNewDoneTask(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Add Completed Task", message: nil, preferredStyle: .alert)
    
    alertController.addTextField {
      (textField) -> Void in
      textField.placeholder = "task name"
      textField.autocapitalizationType = .words
    }
    
    let okAction = UIAlertAction(title: "OK", style: .default) {
      (action) -> Void in
      if let taskName = alertController.textFields?.first?.text {
        self.taskCompletionStore.addTaskCompletion(name: taskName, completionDate: nil)
        self.tableView.reloadData()
      }
    }
    
    alertController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 95
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(applicationDidBecomeActive(_:)),
      name: NSNotification.Name.UIApplicationDidBecomeActive,
      object: nil)
  }
  
  func applicationDidBecomeActive(_ notification: NSNotification) {
    taskCompletionStore.refresh()
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return taskCompletionStore.taskCompletions.count
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      
      let alertController = UIAlertController(title: "Are you sure you want to delete this task?", message: nil, preferredStyle: .alert)
      
      let yesAction = UIAlertAction(title: "Yes", style: .default) {
        (action) -> Void in
          let taskName = self.taskCompletionStore.taskCompletions[indexPath.row].name
          let task = self.taskCompletionStore.getTask(taskName)
          self.taskCompletionStore.deleteTask(task)
          self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
      alertController.addAction(yesAction)
      
      let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
      alertController.addAction(noAction)
      
      present(alertController, animated: true, completion: nil)
    }
    
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // Get a new or recycled cell
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCompletionCell", for: indexPath) as! TaskCompletionCell
    
    taskCompletionStore.refresh()
    let taskCompletion = taskCompletionStore.taskCompletions[indexPath.row]
    
    cell.nameLabel.text = taskCompletion.name
    if let date = taskCompletion.date {
      cell.taskCompleteLabel.text = "Completed: \(dateDifference.itWasEstimate(baseDate: Date(), earlierDate: date))"
    } else {
      cell.taskCompleteLabel.text = "Never completed"
    }
    
    cell.totalCompletes.text = "Total: \(taskCompletion.totalCompletes)"
    
    return cell
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    taskCompletionStore.refresh()
    tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "showTaskDetail"?:
      if let row = tableView.indexPathForSelectedRow?.row {
        let taskName = taskCompletionStore.taskCompletions[row].name
        let task = taskCompletionStore.getTask(taskName)
        let taskDetailViewController = segue.destination as! TaskDetailViewController
        
        taskDetailViewController.task = task
        taskDetailViewController.taskCompletionStore = taskCompletionStore
      }
    default:
      return
    }
  }
  
  
  
}

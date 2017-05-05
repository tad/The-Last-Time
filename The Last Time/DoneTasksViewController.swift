//
//  DoneTasksViewController.swift
//  The Last Time
//
//  Created by Tad Donaghe on 4/22/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import UIKit

class DoneTasksViewController: UITableViewController {
  
  var doneTaskStore: DoneTaskStore!
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
  }()
  
  var dateDifference = DateDifference()
  
  @IBAction func done(_ sender: UIBarButtonItem) {
    
  }
  
  @IBAction func addNewDoneTask(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Add Completed Task", message: nil, preferredStyle: .alert)
    
    alertController.addTextField {
      (textField) -> Void in
      textField.placeholder = "task name"
      textField.autocapitalizationType = .words
    }
    
    let okAction = UIAlertAction(title: "OK", style: .default) {
      (action) -> Void in
      print("PING!!!")
      if let taskName = alertController.textFields?.first?.text {
        self.doneTaskStore.createDoneTask(taskName)
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
    tableView.estimatedRowHeight = 65
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return doneTaskStore.allDoneTasks.count
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    // Update the model
    doneTaskStore.moveDoneTask(from: sourceIndexPath.row, to: destinationIndexPath.row)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // Get a new or recycled cell
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "DoneTaskCell", for: indexPath) as! DoneTaskCell
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableView
    let doneTask = doneTaskStore.allDoneTasks[indexPath.row]
    
    cell.nameLabel.text = doneTask.taskName
//    cell.taskCompleteLabel.text = dateFormatter.string(from: doneTask.dateCompleted)
    cell.taskCompleteLabel.text = dateDifference.itWasEstimate(baseDate: Date(), earlierDate: doneTask.dateCompleted)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let doneTask = doneTaskStore.allDoneTasks[indexPath.row]
      
      let title = "Delete \(doneTask.taskName)?"
      let message = "Are you sure you want to delete this task?"
      
      let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      ac.addAction(cancelAction)
      
      let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
        // Remove the item from the store
        self.doneTaskStore.removeDoneTask(doneTask)
        
        
        // Also remove that row from the table view with an animation
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      })
      ac.addAction(deleteAction)
      
      // Present the alert controller
      present(ac, animated: true, completion: nil)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.reloadData()
  }
  
}

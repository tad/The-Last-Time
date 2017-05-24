//
//  TaskDetailViewController.swift
//  The Last Time
//
//  Created by Tad Donaghe on 5/12/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var task: Task!
  var taskCompletionStore: TaskCompletionStore!
  
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
  }()
  
  @IBOutlet var taskName: UILabel!
  @IBOutlet var tableView: UITableView!
  
  
  override func viewWillAppear(_ animated: Bool) {
    taskName?.text = task.name
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    let tap = UITapGestureRecognizer(target: self, action: #selector(TaskDetailViewController.tapFunction))
    taskName.addGestureRecognizer(tap)
  }
  
  @IBAction func completeAgainNow(_ sender: UIButton) {
    taskCompletionStore.addNewCompletion(forTask: task)
    tableView.reloadData()
  }
  
  func tapFunction(sender:UITapGestureRecognizer) {
    let alertController = UIAlertController(title: "Edit Task Name", message: nil, preferredStyle: .alert)
    
    alertController.addTextField {
      (textField) -> Void in
      textField.text = self.task.name
      textField.autocapitalizationType = .words
    }
    
    let okAction = UIAlertAction(title: "OK", style: .default) {
      (action) -> Void in
      if let taskName = alertController.textFields?.first?.text {
        if taskName.characters.count > 0 {
          self.task.name = taskName
          self.taskName?.text = taskName
          self.taskCompletionStore.saveChanges()
        }
      }
    }
    
    alertController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let completions = task.completions?.count else {
      return 1
    }
    
    return completions
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                
    guard let completion = task.completions?.reversed[indexPath.row] as? Completion, let completionDate = completion.date as Date? else {
      return cell
    }
    
    cell.textLabel?.text = dateFormatter.string(from: completionDate)
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      let completion = task.completions?.reversed[indexPath.row]
      taskCompletionStore.deleteCompletion(forTask: task, completion: completion as! Completion)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    tableView.reloadData()
  }
}



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
    self.tableView.delegate = self
    self.tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  @IBAction func completeAgainNow(_ sender: UIButton) {
    taskCompletionStore.addNewCompletion(forTask: task)
    tableView.reloadData()
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let completions = task.completions?.count else {
      return 1
    }
    
    return completions
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                
    guard let completion = task.completions?[indexPath.row] as? Completion, let completionDate = completion.date as Date? else {
      return cell
    }
    
    cell.textLabel?.text = dateFormatter.string(from: completionDate)
    return cell
  }
}



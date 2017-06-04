//
//  TaskDetailViewController.swift
//  The Last Time
//
//  Created by Tad Donaghe on 5/12/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
  var task: Task!
  var taskCompletionStore: TaskCompletionStore!
  
  var completions = [Completion]()
  
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
  }()
  
  let datePickerTag = 99   // view tag identifiying the date picker view
  var pickerCellRowHeight: CGFloat = 216
  
  // Keep track of which indexPath points to the cell with UIDatePicker
  var datePickerIndexPath: IndexPath?
  
  let datePickerCellID = "datePickerCell"
  let dateCellID = "Cell"

  
  
  @IBOutlet var taskName: UILabel!
  @IBOutlet var tableView: UITableView!
  
  override func viewWillAppear(_ animated: Bool) {
    taskName?.text = task.name
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dateSort = NSSortDescriptor(key: #keyPath(Completion.date), ascending: false)
    completions = task.completions?.sortedArray(using: [dateSort]) as! [Completion]
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    let tap = UITapGestureRecognizer(target: self, action: #selector(TaskDetailViewController.tapFunction))
    taskName.addGestureRecognizer(tap)
  }
  
  @IBAction func dateAction(_ sender: UIDatePicker) {
    var targetedCellIndexPath: IndexPath?
    
    if hasInlineDatePicker() {
      // inline date picker: update the cell's date "above" the date picker cell
      targetedCellIndexPath = IndexPath(row: datePickerIndexPath!.row - 1, section: 0)
    } else {
      // external date picker: update the current "selected" cell's date
      targetedCellIndexPath = tableView.indexPathForSelectedRow!
    }
    
    let cell = tableView.cellForRow(at: targetedCellIndexPath!)
    let targetedDatePicker = sender
    
    // update our data model
    task.completions = NSOrderedSet(array: completions)
    if targetedDatePicker.date < Date() {
      completions[targetedCellIndexPath!.row].date = targetedDatePicker.date as NSDate
      
      taskCompletionStore.saveChanges()
      
      // update the cell's date string
      cell?.textLabel?.text = dateFormatter.string(from: targetedDatePicker.date)
    }
  }
  
  @IBAction func completeAgainNow(_ sender: UIButton) {
    taskCompletionStore.addNewCompletion(forTask: task)
    
    let dateSort = NSSortDescriptor(key: #keyPath(Completion.date), ascending: false)
    completions = task.completions?.sortedArray(using: [dateSort]) as! [Completion]
    tableView.reloadData()
    taskCompletionStore.refresh()
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
}

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let completions = task.completions?.count else {
      return 1
    }
    
    if hasInlineDatePicker() {
      return completions + 1
    }
    
    return completions
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    
    var cellID = dateCellID
    
    if indexPathHasPicker(indexPath) {
      // the indexPath is the one containing the inline date picker
      cellID = datePickerCellID     // the current/opened date picker cell
    }
    
    cell = tableView.dequeueReusableCell(withIdentifier: cellID)
    
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    var modelRow = indexPath.row
    if let path = datePickerIndexPath {
      if path.row <= indexPath.row {
        modelRow = modelRow - 1
      }
    }
    
    if cellID == dateCellID {
      cell?.textLabel?.text = dateFormatter.string(from: completions[modelRow].date! as Date)
    }
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let completion = completions[indexPath.row]
      taskCompletionStore.deleteCompletion(forTask: task, completion: completion)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    let dateSort = NSSortDescriptor(key: #keyPath(Completion.date), ascending: false)
    completions = task.completions?.sortedArray(using: [dateSort]) as! [Completion]
    
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    let cell = tableView.cellForRow(at: indexPath)
    if cell?.reuseIdentifier == dateCellID {
      displayInlineDatePickerForRowAtIndexPath(indexPath)
    } else {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return (indexPathHasPicker(indexPath) ? pickerCellRowHeight : tableView.rowHeight)
  }
  
}

// Helper for datePicker
extension TaskDetailViewController {
  
  func hasPickerForIndexPath(_ indexPath: IndexPath) -> Bool {
    var hasDatePicker = false
    
    let targetedRow = indexPath.row + 1
    
    let checkDatePickerCell = tableView.cellForRow(at: IndexPath(row: targetedRow, section: 0))
    let checkDatePicker = checkDatePickerCell?.viewWithTag(datePickerTag)
    
    hasDatePicker = checkDatePicker != nil
    return hasDatePicker
  }
  
  func updateDatePicker() {
    if let indexPath = datePickerIndexPath {
      let associatedDatePickerCell = tableView.cellForRow(at: indexPath)
      if let targetedDatePicker = associatedDatePickerCell?.viewWithTag(datePickerTag) as! UIDatePicker? {
        let itemData = completions[datePickerIndexPath!.row - 1]
        targetedDatePicker.setDate(itemData.date! as Date , animated: false)
        targetedDatePicker.maximumDate = Date()
      }
    }
  }
  
  func toggleDatePickerForSelectedIndexPath(_ indexPath: IndexPath) {
    
    tableView.beginUpdates()
    
    let indexPaths = [IndexPath(row: indexPath.row + 1, section: 0)]
    
    // check if 'indexPath' has an attached date picker below it
    if hasPickerForIndexPath(indexPath) {
      // found a picker below it, so remove it
      tableView.deleteRows(at: indexPaths, with: .fade)
    } else {
      // didn't find a picker below it, so we should insert it
      tableView.insertRows(at: indexPaths, with: .fade)
    }
    tableView.endUpdates()
  }
  
  func displayInlineDatePickerForRowAtIndexPath(_ indexPath: IndexPath) {
    
    // display the date picker inline with the table content
    tableView.beginUpdates()
    
    var before = false // indicates if the date picker is below "indexPath", help us determine which row to reveal
    
    if hasInlineDatePicker() {
      if let path = datePickerIndexPath {
        before = path.row < indexPath.row
      }
    }
    
    let sameCellClicked = (datePickerIndexPath?.row == indexPath.row + 1)
    
    // remove any date picker cell if it exists
    if hasInlineDatePicker() {
      tableView.deleteRows(at: [IndexPath(row: datePickerIndexPath!.row, section: 0)], with: .fade)
      datePickerIndexPath = nil
    }
    
    if !sameCellClicked {
      // hide the old date picker and display the new one
      let rowToReveal = (before ? indexPath.row - 1 : indexPath.row)
      let indexPathToReveal = IndexPath(row: rowToReveal, section: 0)
      
      toggleDatePickerForSelectedIndexPath(indexPathToReveal)
      datePickerIndexPath = IndexPath(row: indexPathToReveal.row + 1, section: 0)
    }
    
    // always deselect the row containing the start or end date
    tableView.deselectRow(at: indexPath, animated:true)
    
    tableView.endUpdates()
    
    // inform our date picker of the current date to match the current cell
    updateDatePicker()
    
    let dateSort = NSSortDescriptor(key: #keyPath(Completion.date), ascending: false)
    completions = task.completions?.sortedArray(using: [dateSort]) as! [Completion]
    
    tableView.reloadData()

  }
  
  func hasInlineDatePicker() -> Bool {
    return datePickerIndexPath != nil
  }
  
  func indexPathHasPicker(_ indexPath: IndexPath) -> Bool {
    return hasInlineDatePicker() && datePickerIndexPath?.row == indexPath.row
  }
}



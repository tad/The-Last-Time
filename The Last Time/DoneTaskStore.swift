//
//  DoneTaskStore.swift
//  The Last Time
//
//  Created by Tad Donaghe on 4/22/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import UIKit

class DoneTaskStore {
  var allDoneTasks = [DoneTask]()
  
  var itemArchiveUrl: URL = {
    let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentDirectories.first!
    return documentDirectory.appendingPathComponent("doneTasks.archive")
  }()
  
  init() {
    if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveUrl.path) as? [DoneTask] {
      allDoneTasks = archivedItems
    }
  }
  
  @discardableResult func createDoneTask(_ taskName: String) -> DoneTask {
    let newDoneTask = DoneTask(taskName)
    
    allDoneTasks.append(newDoneTask)
    
    return newDoneTask
  }
  
  func moveDoneTask(from fromIndex: Int, to toIndex: Int) {
    if fromIndex == toIndex {
      return
    }
    
    // Get reference to object being moved so you can reinsert it
    let movedDoneTask = allDoneTasks[fromIndex]
    
    // Remove the item from the array
    allDoneTasks.remove(at: fromIndex)
    
    // Insert item in array at new location
    allDoneTasks.insert(movedDoneTask, at: toIndex)
  }
  
  func removeDoneTask(_ doneTask: DoneTask) {
    if let index = allDoneTasks.index(of: doneTask) {
      allDoneTasks.remove(at: index)
    }
  }
  
  func saveChanges() -> Bool {
    print("Saving doneTasks to: \(itemArchiveUrl.path)")
    
    return NSKeyedArchiver.archiveRootObject(allDoneTasks, toFile: itemArchiveUrl.path)
  }
  
}

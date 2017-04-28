//
//  DoneTaskCell.swift
//  The Last Time
//
//  Created by Tad Donaghe on 4/23/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import UIKit

class DoneTaskCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var taskCompleteLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    nameLabel.adjustsFontForContentSizeCategory = true
    taskCompleteLabel.adjustsFontForContentSizeCategory = true
  }
}
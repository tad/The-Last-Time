//
//  DateInterval.swift
//  The Last Time
//
//  Created by Tad Donaghe on 4/30/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import Foundation

class DateDifference {
  func itWasEstimate(baseDate: Date, earlierDate: Date) -> String {
    
    let calendar = Calendar.current
    let requestedComponent: Set<Calendar.Component> = [ .month, .day, .hour, .minute, .second]
    let timeDifference = calendar.dateComponents(requestedComponent, from: baseDate, to: earlierDate)
    
    if timeDifference.minute! < 0 {
      if timeDifference.minute! == -1 {
        return "One minute ago"
      } else {
        return "\(abs(timeDifference.minute!)) minutes ago"
      }
    }
    
    return "Just now"
  }
}

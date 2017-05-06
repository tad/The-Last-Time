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
    let requestedComponent: Set<Calendar.Component> = [ .year, .month, .day, .hour, .minute, .second]
    
    let baseDate = Date(timeIntervalSinceReferenceDate: baseDate
      .timeIntervalSinceReferenceDate.rounded())
    let earlierDate = Date(timeIntervalSinceReferenceDate: earlierDate
      .timeIntervalSinceReferenceDate.rounded())
    
    let timeDifference = calendar.dateComponents(requestedComponent, from: baseDate, to: earlierDate)
    
    if timeDifference.year! < 0 {
      if timeDifference.year! == -1 {
        return "Last year"
      } else {
        return "\(abs(timeDifference.year!)) years ago"
      }
    }
    
    if timeDifference.month! < 0 {
      if timeDifference.month! == -1 {
        return "A month ago"
      } else {
        return "\(abs(timeDifference.month!)) months ago"
      }
    }
    
    if timeDifference.day! < 0 {
      if timeDifference.day! == -1 {
        return "Yesterday"
      } else {
        return "\(abs(timeDifference.day!)) days ago"
      }
    }
    
    if timeDifference.hour! < 0 {
      if timeDifference.hour! == -1 {
        return "An hour ago"
      } else {
        return "\(abs(timeDifference.hour!)) hours ago"
      }
    }
    
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

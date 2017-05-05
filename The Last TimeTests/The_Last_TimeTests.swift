//
//  The_Last_TimeTests.swift
//  The Last TimeTests
//
//  Created by Tad Donaghe on 4/22/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import XCTest
@testable import The_Last_Time

class The_Last_TimeTests: XCTestCase {
  
  var dateDifference: DateDifference!
  var calendar: Calendar!
  var now: Date!
  
  override func setUp() {
    super.setUp()
    dateDifference = DateDifference()
    
    calendar = Calendar.current
    now = Date()
  }
  
  override func tearDown() {
    dateDifference = nil
    super.tearDown()
  }
  
  
  func testLessThanAMinuteAgo() {
    let tenSecondsAgo = calendar.date(byAdding: .second, value: -10, to: now)
    
    XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: tenSecondsAgo!), "Just now")
  }
  
  func testOneMinuteAgo() {
    let oneMinuteAgo = calendar.date(byAdding: .minute, value: -1, to: now)
    
    XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: oneMinuteAgo!), "One minute ago")
  }
  
  func test2To59MinutesAgo() {
    
    for minute in 2...59 {
      let earlierTime = calendar.date(byAdding: .minute, value: 0 - minute, to: now)
      XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: earlierTime!), "\(minute) minutes ago")
    }
  }
  
  func testOneHourAgo() {
    let oneHourAgo = calendar.date(byAdding: .hour, value: -1, to: now)
    
    XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: oneHourAgo!), "An hour ago")
  }
  
  func testOneHourOneMinuteOneSecondAgo() {
    var oneHourOneMinuteOneSecondAgo = calendar.date(byAdding: .hour, value: -1, to: now!)
    oneHourOneMinuteOneSecondAgo = calendar.date(byAdding: .minute, value: -1, to: oneHourOneMinuteOneSecondAgo!)
    oneHourOneMinuteOneSecondAgo = calendar.date(byAdding: .second, value: -1, to: oneHourOneMinuteOneSecondAgo!)
    
    XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: oneHourOneMinuteOneSecondAgo!), "An hour ago")
  }
  
  func test2To23HoursAgo() {
    for hour in 2...23 {
      let earlierTime = calendar.date(byAdding: .hour, value: 0 - hour, to: now)
      XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: earlierTime!), "\(hour) hours ago")
    }
  }
  
  func testOneDayAgo() {
    let oneDayAgo = calendar.date(byAdding: .day, value: -1, to: now)
    
    XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: oneDayAgo!), "Yesterday")
  }
  
  func test2To28DaysAgo() {
    for day in 2...28 {
      let earlierTime = calendar.date(byAdding: .day, value: 0 - day, to: now)
      XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: earlierTime!), "\(day) days ago")
    }
  }
  
  func testOneMonthAgo() {
    let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now)
    
    XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: oneMonthAgo!), "A month ago")
  }
  
  func test2To11MonthsAgo() {
    for month in 2...11 {
      let earlierTime = calendar.date(byAdding: .month, value: 0 - month, to: now)
      XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: earlierTime!), "\(month) months ago")
    }
  }
  
  func testOneYearAGo() {
    let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now)
    
    XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: oneYearAgo!), "Last year")
  }
  
  func testManyYearsAgo() {
    for year in 2...99 {
      let earlierTime = calendar.date(byAdding: .year, value: 0 - year, to: now)
      XCTAssertEqual(dateDifference.itWasEstimate(baseDate: now, earlierDate: earlierTime!), "\(year) years ago")
    }
  }

  
  
  
}

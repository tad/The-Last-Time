//
//  Completion+CoreDataProperties.swift
//  The Last Time
//
//  Created by Tad Donaghe on 5/11/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import Foundation
import CoreData


extension Completion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Completion> {
        return NSFetchRequest<Completion>(entityName: "Completion")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var task: Task?

}

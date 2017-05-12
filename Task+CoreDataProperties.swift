//
//  Task+CoreDataProperties.swift
//  The Last Time
//
//  Created by Tad Donaghe on 5/11/17.
//  Copyright © 2017 Tad Donaghe. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var completions: NSOrderedSet?

}

// MARK: Generated accessors for completions
extension Task {

    @objc(insertObject:inCompletionsAtIndex:)
    @NSManaged public func insertIntoCompletions(_ value: Completion, at idx: Int)

    @objc(removeObjectFromCompletionsAtIndex:)
    @NSManaged public func removeFromCompletions(at idx: Int)

    @objc(insertCompletions:atIndexes:)
    @NSManaged public func insertIntoCompletions(_ values: [Completion], at indexes: NSIndexSet)

    @objc(removeCompletionsAtIndexes:)
    @NSManaged public func removeFromCompletions(at indexes: NSIndexSet)

    @objc(replaceObjectInCompletionsAtIndex:withObject:)
    @NSManaged public func replaceCompletions(at idx: Int, with value: Completion)

    @objc(replaceCompletionsAtIndexes:withCompletions:)
    @NSManaged public func replaceCompletions(at indexes: NSIndexSet, with values: [Completion])

    @objc(addCompletionsObject:)
    @NSManaged public func addToCompletions(_ value: Completion)

    @objc(removeCompletionsObject:)
    @NSManaged public func removeFromCompletions(_ value: Completion)

    @objc(addCompletions:)
    @NSManaged public func addToCompletions(_ values: NSOrderedSet)

    @objc(removeCompletions:)
    @NSManaged public func removeFromCompletions(_ values: NSOrderedSet)

}

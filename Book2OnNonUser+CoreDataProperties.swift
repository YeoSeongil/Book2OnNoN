//
//  Book2OnNonUser+CoreDataProperties.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/8/24.
//
//

import Foundation
import CoreData


extension Book2OnNonUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book2OnNonUser> {
        return NSFetchRequest<Book2OnNonUser>(entityName: "Book2OnNonUser")
    }

    @NSManaged public var isRegister: Bool
    @NSManaged public var name: String?
    @NSManaged public var finishedReadingBook: NSSet?
    @NSManaged public var interestedReadingBook: NSSet?
    @NSManaged public var readingBook: NSSet?

}

// MARK: Generated accessors for finishedReadingBook
extension Book2OnNonUser {

    @objc(addFinishedReadingBookObject:)
    @NSManaged public func addToFinishedReadingBook(_ value: FinishedReadingBooks)

    @objc(removeFinishedReadingBookObject:)
    @NSManaged public func removeFromFinishedReadingBook(_ value: FinishedReadingBooks)

    @objc(addFinishedReadingBook:)
    @NSManaged public func addToFinishedReadingBook(_ values: NSSet)

    @objc(removeFinishedReadingBook:)
    @NSManaged public func removeFromFinishedReadingBook(_ values: NSSet)

}

// MARK: Generated accessors for interestedReadingBook
extension Book2OnNonUser {

    @objc(addInterestedReadingBookObject:)
    @NSManaged public func addToInterestedReadingBook(_ value: InterestedReadingBooks)

    @objc(removeInterestedReadingBookObject:)
    @NSManaged public func removeFromInterestedReadingBook(_ value: InterestedReadingBooks)

    @objc(addInterestedReadingBook:)
    @NSManaged public func addToInterestedReadingBook(_ values: NSSet)

    @objc(removeInterestedReadingBook:)
    @NSManaged public func removeFromInterestedReadingBook(_ values: NSSet)

}

// MARK: Generated accessors for readingBook
extension Book2OnNonUser {

    @objc(addReadingBookObject:)
    @NSManaged public func addToReadingBook(_ value: ReadingBooks)

    @objc(removeReadingBookObject:)
    @NSManaged public func removeFromReadingBook(_ value: ReadingBooks)

    @objc(addReadingBook:)
    @NSManaged public func addToReadingBook(_ values: NSSet)

    @objc(removeReadingBook:)
    @NSManaged public func removeFromReadingBook(_ values: NSSet)

}

extension Book2OnNonUser : Identifiable {

}

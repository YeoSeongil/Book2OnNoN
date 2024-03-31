//
//  User+CoreDataProperties.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/1/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var isRegister: Bool
    @NSManaged public var finishedReadingBook: FinishedReadingBook?
    @NSManaged public var interestedReadingBook: InterestedReadingBook?
    @NSManaged public var readingBook: ReadingBook?

}

extension User : Identifiable {

}

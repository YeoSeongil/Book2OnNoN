//
//  ReadingBook+CoreDataProperties.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/1/24.
//
//

import Foundation
import CoreData


extension ReadingBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReadingBook> {
        return NSFetchRequest<ReadingBook>(entityName: "ReadingBook")
    }

    @NSManaged public var isbn: String?
    @NSManaged public var name: String?
    @NSManaged public var readingPage: Int64
    @NSManaged public var startReadingDate: Date?

}

extension ReadingBook : Identifiable {

}

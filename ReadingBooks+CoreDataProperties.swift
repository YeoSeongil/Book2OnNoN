//
//  ReadingBooks+CoreDataProperties.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/6/24.
//
//

import Foundation
import CoreData


extension ReadingBooks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReadingBooks> {
        return NSFetchRequest<ReadingBooks>(entityName: "ReadingBooks")
    }

    @NSManaged public var isbn: String?
    @NSManaged public var name: String?
    @NSManaged public var readingPage: String?
    @NSManaged public var startReadingDate: String?
    @NSManaged public var user3: Book2OnNonUser?

}

extension ReadingBooks : Identifiable {

}

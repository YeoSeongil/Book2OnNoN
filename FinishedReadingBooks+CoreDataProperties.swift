//
//  FinishedReadingBooks+CoreDataProperties.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/6/24.
//
//

import Foundation
import CoreData


extension FinishedReadingBooks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinishedReadingBooks> {
        return NSFetchRequest<FinishedReadingBooks>(entityName: "FinishedReadingBooks")
    }

    @NSManaged public var comment: String?
    @NSManaged public var finishReadingDate: String?
    @NSManaged public var isbn: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var startReadingDate: String?
    @NSManaged public var user1: Book2OnNonUser?

}

extension FinishedReadingBooks : Identifiable {

}

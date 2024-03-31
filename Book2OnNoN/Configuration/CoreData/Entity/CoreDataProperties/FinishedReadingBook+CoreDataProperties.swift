//
//  FinishedReadingBook+CoreDataProperties.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/1/24.
//
//

import Foundation
import CoreData


extension FinishedReadingBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinishedReadingBook> {
        return NSFetchRequest<FinishedReadingBook>(entityName: "FinishedReadingBook")
    }

    @NSManaged public var comment: String?
    @NSManaged public var finishReadingDate: Date?
    @NSManaged public var isbn: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Float
    @NSManaged public var startReadingDate: Date?

}

extension FinishedReadingBook : Identifiable {

}

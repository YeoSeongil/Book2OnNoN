//
//  FinishedReadingBook+CoreDataProperties.swift
//  
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

    @NSManaged public var name: String?
    @NSManaged public var isbn: String?
    @NSManaged public var startReadingDate: Date?
    @NSManaged public var finishReadingDate: Date?
    @NSManaged public var comment: String?
    @NSManaged public var rating: Float

}

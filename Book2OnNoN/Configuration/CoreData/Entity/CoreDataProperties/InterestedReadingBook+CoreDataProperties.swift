//
//  InterestedReadingBook+CoreDataProperties.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/1/24.
//
//

import Foundation
import CoreData


extension InterestedReadingBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InterestedReadingBook> {
        return NSFetchRequest<InterestedReadingBook>(entityName: "InterestedReadingBook")
    }

    @NSManaged public var comment: String?
    @NSManaged public var isbn: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Float

}

extension InterestedReadingBook : Identifiable {

}

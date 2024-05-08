//
//  InterestedReadingBooks+CoreDataProperties.swift
//  Book2OnNoN
//
//  Created by 여성일 on 5/8/24.
//
//

import Foundation
import CoreData


extension InterestedReadingBooks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InterestedReadingBooks> {
        return NSFetchRequest<InterestedReadingBooks>(entityName: "InterestedReadingBooks")
    }

    @NSManaged public var comment: String?
    @NSManaged public var isbn: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var thumbnail: String?
    @NSManaged public var user: Book2OnNonUser?

}

extension InterestedReadingBooks : Identifiable {

}

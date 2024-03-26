//
//  LookUpItem.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/26/24.
//

import Foundation

// MARK: - Welcome
struct LookUp: Codable {
    let version: String
    let logo: String
    let title: String
    let link: String
    let pubDate: String
    let totalResults, startIndex, itemsPerPage: Int
    let query: String
    let searchCategoryID: Int
    let searchCategoryName: String
    let item: [LookUpItem]

    enum CodingKeys: String, CodingKey {
        case version, logo, title, link, pubDate, totalResults, startIndex, itemsPerPage, query
        case searchCategoryID = "searchCategoryId"
        case searchCategoryName, item
    }
}

// MARK: - Item
struct LookUpItem: Codable {
    let title: String
    let link: String
    let author, pubDate, description, isbn: String
    let isbn13: String
    let itemID, priceSales, priceStandard: Int
    let mallType, stockStatus: String
    let mileage: Int
    let cover: String
    let categoryID: Int
    let categoryName, publisher: String
    let salesPoint: Int
    let adult, fixedPrice: Bool
    let customerReviewRank: Int
    let subInfo: SubInfo

    enum CodingKeys: String, CodingKey {
        case title, link, author, pubDate, description, isbn, isbn13
        case itemID = "itemId"
        case priceSales, priceStandard, mallType, stockStatus, mileage, cover
        case categoryID = "categoryId"
        case categoryName, publisher, salesPoint, adult, fixedPrice, customerReviewRank, subInfo
    }
}

// MARK: - SubInfo
struct LookUpSubInfo: Codable {
    let ebookList: [LookUpEbookList]
    let usedList: LookUpUsedList
    let subTitle, originalTitle: String
    let itemPage: Int
}

// MARK: - EbookList
struct LookUpEbookList: Codable {
    let itemID: Int
    let isbn, isbn13: String
    let priceSales: Int
    let link: String

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case isbn, isbn13, priceSales, link
    }
}

// MARK: - UsedList
struct LookUpUsedList: Codable {
    let aladinUsed, userUsed, spaceUsed: LookUpUsed
}

// MARK: - Used
struct LookUpUsed: Codable {
    let itemCount, minPrice: Int
    let link: String
}

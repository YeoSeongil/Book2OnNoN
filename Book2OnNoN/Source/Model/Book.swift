//
//  Book.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/11/24.
//

import Foundation

// MARK: - Welcome
struct Book: Codable {
    let version: String
    let logo: String
    let title: String
    let link: String
    let pubDate: String
    let totalResults, startIndex, itemsPerPage: Int
    let query: String
    let searchCategoryID: Int
    let searchCategoryName: String
    let item: [Item]

    enum CodingKeys: String, CodingKey {
        case version, logo, title, link, pubDate, totalResults, startIndex, itemsPerPage, query
        case searchCategoryID = "searchCategoryId"
        case searchCategoryName, item
    }
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let author, pubDate, description, isbn: String
    let isbn13: String
    let itemID, priceSales, priceStandard: Int
    let mallType: MallType
    let stockStatus: String
    let mileage: Int
    let cover: String
    let categoryID: Int
    let categoryName, publisher: String
    let salesPoint: Int
    let adult, fixedPrice: Bool
    let customerReviewRank: Int
    let seriesInfo: SeriesInfo?
    let subInfo: SubInfo

    enum CodingKeys: String, CodingKey {
        case title, link, author, pubDate, description, isbn, isbn13
        case itemID = "itemId"
        case priceSales, priceStandard, mallType, stockStatus, mileage, cover
        case categoryID = "categoryId"
        case categoryName, publisher, salesPoint, adult, fixedPrice, customerReviewRank, seriesInfo, subInfo
    }
}

enum MallType: String, Codable {
    case book = "BOOK"
}

// MARK: - SeriesInfo
struct SeriesInfo: Codable {
    let seriesID: Int
    let seriesLink: String
    let seriesName: String

    enum CodingKeys: String, CodingKey {
        case seriesID = "seriesId"
        case seriesLink, seriesName
    }
}

// MARK: - SubInfo
struct SubInfo: Codable {
}

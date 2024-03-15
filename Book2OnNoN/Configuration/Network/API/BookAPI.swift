//
//  BookAPI.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/12/24.
//

import Foundation
import RxSwift
import Alamofire

public enum BookAPI {
    case searchBook(title: String, type: String, page: Int)
}

extension BookAPI: Router, URLRequestConvertible {
    
    public var baseURL: String {
        return API.baseUrl
    }
    
    public var path: String {
        switch self {
        case .searchBook:
            return "ttb/api/ItemSearch.aspx"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .searchBook:
            return .get
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .searchBook:
            return nil
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case let .searchBook(title, type, page):
            return [
                "ttbkey" : API.key,
                "Query" : title,
                "QueryType" : type,
                "MaxResults" : 10,
                "start": page,
                "SearchTarget": "Book",
                "output": "js",
                "Version": "20131101",
            ]
        }
    }
    
    public var encoding: ParameterEncoding? {
        switch self {
        case .searchBook:
            return URLEncoding.default
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + path)
        var request = URLRequest(url: url!)
        
        request.method = method
        
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        
        return request
    }
    
    public func urlTest() {
        let url = URL(string: baseURL + path)
        print(url!)
    }
}

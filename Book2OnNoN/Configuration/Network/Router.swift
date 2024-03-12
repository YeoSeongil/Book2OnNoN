//
//  Router.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/12/24.
//

import Foundation
import Alamofire

public protocol Router {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String]? { get }
    var parameters: [String : Any]? { get }
    var encoding: ParameterEncoding? { get }
}

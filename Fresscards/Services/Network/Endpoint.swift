//
//  Endpoint.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 15.02.2023.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var urlComponents: URLComponents? { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: Codable? { get }
}


enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

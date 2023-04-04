//
//  RequestError.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 15.02.2023.
//


enum RequestError: Error {
    case before // stupid workaround to make possible return errors before actual HTTP request TODO: eliminate this
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case notFound
    case unexpectedStatusCode
    case unexpectedHeaders
    case unknown
    case custom(message: String)
    
    var customMessage: String {
        switch self {
        case .before:
            return "Error happens before actual request" // TODO: eliminate this
        case .decode:
            return "Decode error"
        case .noResponse:
            return "No response"
        case .unauthorized:
            return "Unauthorized"
        case .notFound:
            return "Not Found"
        case .unexpectedHeaders:
            return "Unexpected Headers"
        case .unexpectedStatusCode:
            return "Unexpected Status Code"
        case .custom(let message):
            return message
        default:
            return "Unknown error"
        }
    }
}


struct RequestErrorMessage: Decodable {
    var detail: String
}

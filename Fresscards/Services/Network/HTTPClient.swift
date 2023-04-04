//
//  HTTPClient.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 15.02.2023.
//

import Foundation
import SwiftUI

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

/// https://betterprogramming.pub/async-await-generic-network-layer-with-swift-5-5-2bdd51224ea9

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        guard let url = endpoint.urlComponents?.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        if let header = endpoint.header {
            request.allHTTPHeaderFields = header
        }
        
        let jsonEncoder = JSONEncoder()
        
        if let body = endpoint.body {
            request.httpBody = try? jsonEncoder.encode(body)
        }
        
//        print(String(decoding: request.httpBody!, as: UTF8.self))
//        print("--------")
//        if let data = with_data {
//            request.httpBody = try? jsonEncoder.encode(data)
//        }
        
        //        print(request.allHTTPHeaderFields)
        //        print(request.httpBody)
        
        //        let str = String(decoding: request.httpBody!, as: UTF8.self)
        //        print(str)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
//            print(String(decoding: data, as: UTF8.self))
            
//            print(data)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ decoder in
                /// This allows to decode date in 2023-02-17 format, ton only in ISO
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withFullDate]
                if let date = formatter.date(from: dateString) {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            })
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? decoder.decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                
                
                
//                let str = String(decoding: data, as: UTF8.self)
//                print(str)
                
                /// Here we try to obtain new access token by using refresh_token
                guard let errorDetailDecodedResponse: RequestErrorMessage = try? decoder.decode(RequestErrorMessage.self, from: data) else {
                    return .failure(.unauthorized)
                }
                
//                if errorDetailDecodedResponse.detail == "Error decoding token (Signature Expired)" {
//                    print("401 - trying to obtain new tokens pair...")
//                    let tokens = await UserService().useRefreshToken()
//                    switch tokens {
//                    case .success(let tokensResult):
//                        //                        print(tokensResult)
//                        UserService().saveFreshRefreshTokens(tokens: tokensResult)
//                        return await sendRequest(endpoint: endpoint, responseModel: responseModel)
//                    case .failure(let tokensError):
//                        log("useRefreshToken request failed with error: \(tokensError.customMessage)")
//
//                        // TODO: case of expires refresh_token
//                    }
//                    /// End of refresh token obtain block
//
//                }
                return .failure(.custom(message: errorDetailDecodedResponse.detail))
                
            default:
                // Unexpected Status Code Case
                
                guard let errorDetailDecodedResponse: RequestErrorMessage = try? decoder.decode(RequestErrorMessage.self, from: data) else {
                    return .failure(.unexpectedStatusCode)
                }
                
                return .failure(.custom(message: errorDetailDecodedResponse.detail))
                
            }
        } catch {
            return .failure(.unknown)
        }
    }
}


extension HTTPClient {
    func sendMultipartFormAuthRequest<T: Decodable>(
        endpoint: Endpoint,
        email: String,
        password: String,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        guard let url = endpoint.urlComponents?.url else {
            return .failure(.invalidURL)
        }
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: url)
        //request.httpMethod = endpoint.method.rawValue
        request.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=X-\(boundary)-BOUNDARY", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("--X-\(boundary)-BOUNDARY\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n\(email)\r\n".data(using: .utf8)!)
        data.append("--X-\(boundary)-BOUNDARY\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"password\"\r\n\r\n\(password)\r\n".data(using: .utf8)!)
        data.append("--X-\(boundary)-BOUNDARY--".data(using: .utf8)!)
        
        //        let str = String(decoding: data, as: UTF8.self)
        //        print(str)
        
        request.httpBody = data as Data
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ decoder in
                /// This allows to decode date in 2023-02-17 format, ton only in ISO
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withFullDate]
                if let date = formatter.date(from: dateString) {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            })
            
//            print(response.statusCode)
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? decoder.decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                guard let errorDetailDecodedResponse: RequestErrorMessage = try? decoder.decode(RequestErrorMessage.self, from: data) else {
                    return .failure(.unauthorized)
                }
                return .failure(.custom(message: errorDetailDecodedResponse.detail))
            case 404:
                guard let errorDetailDecodedResponse: RequestErrorMessage = try? decoder.decode(RequestErrorMessage.self, from: data) else {
                    return .failure(.notFound)
                }
                return .failure(.custom(message: errorDetailDecodedResponse.detail))
            default:
                
                guard let errorDetailDecodedResponse: RequestErrorMessage = try? decoder.decode(RequestErrorMessage.self, from: data) else {
                    return .failure(.unexpectedStatusCode)
                }
                
                return .failure(.custom(message: errorDetailDecodedResponse.detail))
                
            }
        } catch {
            return .failure(.unknown)
        }
    }
}


extension HTTPClient {
    func uploadImageRequest<T: Decodable>(
        endpoint: Endpoint,
        image: UIImage,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        guard let url = endpoint.urlComponents?.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let header = endpoint.header {
            request.allHTTPHeaderFields = header
        }
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        //         And the boundary is also set here
        //        request.setValue("multipart/form-data; boundary=X-ENERGRAM-BOUNDARY", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("--X-ENERGRAM-BOUNDARY\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"uploads\"; filename=\"userpic\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.75)!)
        data.append("\r\n--X-ENERGRAM-BOUNDARY--".data(using: .utf8)!)

        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: data)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            let decoder = JSONDecoder()
            //            decoder.dateDecodingStrategy = .custom({ decoder in
            //                /// This allows to decode date in 2023-02-17 format, ton only in ISO
            //                let container = try decoder.singleValueContainer()
            //                let dateString = try container.decode(String.self)
            //                let formatter = ISO8601DateFormatter()
            //                formatter.formatOptions = [.withFullDate]
            //                if let date = formatter.date(from: dateString) {
            //                    return date
            //                }
            //                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            //            })
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? decoder.decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}


extension HTTPClient {
    func getPrettyPrintedJSONResponse(endpoint: Endpoint) async -> Result<String, RequestError> {
        
        guard let url = endpoint.urlComponents?.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                return .success(data.prettyPrintedJSONString!)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}

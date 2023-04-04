//
//  GithubEndpoints.swift
//  YourFirstCommit
//
//  Created by Alex Antipov on 15.02.2023.
//

import Foundation

enum FresscardsEndpoint {
    case apiInfo
    case generate(request: NeuralRequest)
//    case latestPriceForCountry(countryCode: String)
//    case appliances
//
//    case userLogin
//    case userRegister(email: String, password: String)
//    case resetPassword(email: String)
//    case secretPage
//    case refreshToken
//
//    case userProfile(id: String)
//    case deleteProfile(id: String)
//    case userpic
}

extension FresscardsEndpoint: Endpoint {


    
    
    
    var urlComponents: URLComponents? {
        switch self {
        case .apiInfo:
            return URLComponents(string: "\(self.host)/info")
        case .generate:
            return URLComponents(string: "\(self.host)/generate")
            //        case .pricesForCountry(let countryCode):
            //            return URLComponents(string: "\(self.host)/price/\(countryCode)/all")
            //        case .latestPriceForCountry(let countryCode):
            //            return URLComponents(string: "\(self.host)/price/\(countryCode)/latest")
            //        case .appliances:
            //            return URLComponents(string: "\(self.host)/appliance/all")
            //
            //        case .userLogin, .refreshToken:
            //            return URLComponents(string: "\(self.host)/token")
            //        case .userRegister:
            //            return URLComponents(string: "\(self.host)/users")
            //        case .resetPassword:
            //            return URLComponents(string: "\(self.host)/user/password_forgot")
            //        case .secretPage:
            //            return URLComponents(string: "\(self.host)/secretpage")
            //
            //        case .userProfile(let id):
            //            return URLComponents(string: "\(self.host)/users/\(id)")
            //        case .deleteProfile(let id):
            //            return URLComponents(string: "\(self.host)/users/\(id)")
            ////            return URLComponents(string: "\(self.host)/users/642819001970d95b06b652fe")
            //
            //        case .userpic:
            //            return URLComponents(string: "\(self.host)/userpic")
            //        }
        }
    }
    
    var host: String {
        return "https://fresscards.ress.ws/api/v1"
//        return "http://127.0.0.1:8000"
    }
    
    
    var method: RequestMethod {
        switch self {
        case .generate:
            return .post
//        case .refreshToken:
//            return .patch
//        case .deleteProfile:
//            return .delete
        default:
            return .get
        }
    }
    
    var header: [String: String]? {
        // Access Token to use in Bearer header
//        var accessToken: String? = nil
//
//        if let authData = UserService().readAuthData() {
//            accessToken = authData.access_token
//        }
//
        switch self {
//        case .userLogin:
//            return nil
        case .generate:
            return ["Content-Type": "application/json;charset=utf-8"]
//        case .userpic:
//            if accessToken == nil {
//                return nil
//            }
//            return ["Authorization": "Bearer \(accessToken ?? "--not present--")", "Content-Type": "multipart/form-data; boundary=X-ENERGRAM-BOUNDARY"]
        default:
//            if accessToken == nil {
                return nil
//            }
//            return ["Authorization": "Bearer \(accessToken ?? "--not present--")", "Content-Type": "application/json;charset=utf-8"]
        }
    }
    
        var body: Codable? {
            switch self {
            case .generate(let request):
                    return request
                //        case .userRegister(let email, let password):
                //            return ["email": email, "password": password]
                //        case .resetPassword(let email):
                //            return ["email": email]
                //        case .refreshToken:
                //            guard let authData = UserService().readAuthData() else {
                //                log("> Can't get authData in EnergramEndpoint.swift, this should not happens")
                //                return nil
                //            }
                //            return ["refresh_token": authData.refresh_token]
            default:
                return nil
            }
        }
    }




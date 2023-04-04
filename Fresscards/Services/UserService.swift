////
////  UserService.swift
////  Energram
////
////  Created by Alex Antipov on 21.02.2023.
////
//
//import Foundation
//import SwiftUI
//
//
//struct SecretPageResponse: Codable {
//    var message: String
//}
//
//struct UserDeleteResponse: Codable {
//    var result: String
//}
//
//protocol UserServiceable {
//    func requestLogin(email: String, password: String) async -> Result<LoginResponse, RequestError>
//    func requestRegister(email: String, password: String) async -> Result<User, RequestError>
//    func requestPasswordReset(email: String) async -> Result<ForgottenPasswordResetRequestResponse, RequestError>
//    func useRefreshToken() async -> Result<RefreshTokenResponse, RequestError>
//    func getSecretPage() async -> Result<SecretPageResponse, RequestError>
//    func getUserProfile(id: String) async -> Result<User, RequestError>
//}
//
//struct UserService: HTTPClient, UserServiceable {
//
//    func requestLogin(email: String, password: String) async -> Result<LoginResponse, RequestError> {
//        return await sendMultipartFormAuthRequest(endpoint: EnergramEndpoint.userLogin, email: email, password:password, responseModel: LoginResponse.self)
//    }
//
//    func requestRegister(email: String, password: String) async -> Result<User, RequestError> {
//        return await sendRequest(endpoint: EnergramEndpoint.userRegister(email: email, password:password), responseModel: User.self)
//    }
//
//    func requestPasswordReset(email: String) async -> Result<ForgottenPasswordResetRequestResponse, RequestError> {
//        return await sendRequest(endpoint: EnergramEndpoint.resetPassword(email: email), responseModel: ForgottenPasswordResetRequestResponse.self)
//    }
//
//    func useRefreshToken() async -> Result<RefreshTokenResponse, RequestError> {
//        return await sendRequest(endpoint: EnergramEndpoint.refreshToken, responseModel: RefreshTokenResponse.self)
//    }
//
//    func getSecretPage() async -> Result<SecretPageResponse, RequestError> {
//        return await sendRequest(endpoint: EnergramEndpoint.secretPage, responseModel: SecretPageResponse.self)
//    }
//
//    func getUserProfile(id: String) async -> Result<User, RequestError> {
//        return await sendRequest(endpoint: EnergramEndpoint.userProfile(id: id), responseModel: User.self)
//    }
//
//    func uploadUserpic(image: UIImage) async -> Result<UserpicUploadResponse, RequestError> {
//        return await uploadImageRequest(endpoint: EnergramEndpoint.userpic, image: image, responseModel: UserpicUploadResponse.self)
//    }
//
//    func deleteProfile() async -> Result<UserDeleteResponse, RequestError> {
//        if let authData = self.readAuthData() {
//            return await sendRequest(endpoint: EnergramEndpoint.deleteProfile(id: authData.id), responseModel: UserDeleteResponse.self)
//        } else {
//            return .failure(RequestError.custom(message: "Cannot read user's auth data from device"))
//        }
//    }
//
//
//    func saveAuthData(data: LoginResponse) {
//        let authData = AuthData(id: data.user.id, email: data.user.email, access_token: data.access_token, refresh_token: data.refresh_token)
//        SettingsManager.shared.setValue(name: SettingsNames.userEmail, value: authData.email)
//        SettingsManager.shared.setValue(name: SettingsNames.userId, value: authData.id)
//        SettingsManager.shared.setValue(name: SettingsNames.accessToken, value: authData.access_token)
//        SettingsManager.shared.setValue(name: SettingsNames.refreshToken, value: authData.refresh_token)
//    }
//
//    func saveFreshRefreshTokens(tokens: RefreshTokenResponse) {
//        SettingsManager.shared.setValue(name: SettingsNames.accessToken, value: tokens.access_token)
//        SettingsManager.shared.setValue(name: SettingsNames.refreshToken, value: tokens.refresh_token)
//        print("Saved new refresh tokens")
//    }
//
//    func readAuthData() -> AuthData? {
//        let email: String = SettingsManager.shared.getStringValue(name: SettingsNames.userEmail)
//        let id: String = SettingsManager.shared.getStringValue(name: SettingsNames.userId)
//        let access_token: String = SettingsManager.shared.getStringValue(name: SettingsNames.accessToken)
//        let refresh_token: String = SettingsManager.shared.getStringValue(name: SettingsNames.refreshToken)
//
//        if [id, email, access_token, refresh_token].allSatisfy({ $0.isEmpty == false }){
//            //print("all not empty, good")
//            return AuthData(id: id, email: email, access_token: access_token, refresh_token: refresh_token)
//        }else{
//            //print("all empty, bad")
//            return nil
//        }
//    }
//
//    func eraseAuthData() {
//        SettingsManager.shared.setValue(name: SettingsNames.userEmail, value: "")
//        SettingsManager.shared.setValue(name: SettingsNames.userId, value: "")
//        SettingsManager.shared.setValue(name: SettingsNames.accessToken, value: "")
//        SettingsManager.shared.setValue(name: SettingsNames.refreshToken, value: "")
//    }
//
//
//}

//
//  Notifications.swift
//  Energram
//
//  Created by Alex Antipov on 19.02.2023.
//


import Foundation

extension Notification.Name {
    static var appLaunching = Notification.Name("app.launching")
    static var appClosing = Notification.Name("app.closing")
    static var cardSavedFromGenerator = Notification.Name("action.card.saved.from.generator")
}

// Method to fire notifications
extension Notification {
    static func fire(name: Notification.Name, payload: Any? = nil){
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["payload":payload ?? "no-data"])
    }
}
extension NotificationCenter {
    static func listen(name: Notification.Name, completion: @escaping ((Any) -> Void)) {
        
        NotificationCenter.default.addObserver(
            forName: name,
            object: nil,
            queue: .main
        ) { (notification) in
            guard let payload: String = notification.userInfo!["payload"] as? String
            else { print("Can not get string payload"); return }
            completion(payload)
        }
    }
    
    static func simple(name: Notification.Name, completion: @escaping (() -> Void)) {
        
        NotificationCenter.default.addObserver(
            forName: name,
            object: nil,
            queue: .main
        ) { (notification) in
            completion()
        }
    }
}


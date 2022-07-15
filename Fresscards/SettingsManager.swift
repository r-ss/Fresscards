//
//  SettingsManager.swift
//  Fresscards
//
//  Created by Alex Antipov on 15.07.2022.
//

import Foundation

struct SettingsItem {
    var name: String
    var type: String
    var defaultValue: Any
}

class SettingsManager {
    
    private let defaults = UserDefaults.standard
    private var settings: [SettingsItem] = [
        SettingsItem(name: "AutoCapitalization", type: "Bool", defaultValue: false)
    ]
    
    
//    init(){
//        self.settings = [
//            
//        ]
//    }
//    
    func createAndSaveDefault() {
        for item in self.settings {
            defaults.set(item.defaultValue, forKey: item.name)
        }
    }
    
    private func getSettingItem(withName: String) -> SettingsItem {
        let idx = self.settings.firstIndex(where: { $0.name == withName })!
        return self.settings[idx]
    }
    
    public func getValue(name: String) -> Any {
        let item = getSettingItem(withName: name)
        switch item.type {
            case "Bool":
                return UserDefaults.standard.bool(forKey: item.name)
            default:
                // in other cases we assume String
                return UserDefaults.standard.string(forKey: item.name)!
        }
    }
    
    public func setValue(name: String, value: Any) {
        let item = getSettingItem(withName: name)
        defaults.set(value, forKey: item.name)
    }
    
    public func getStringValue(name: String) -> String {
        let item = getSettingItem(withName: name)
        return UserDefaults.standard.string(forKey: item.name)!
    }
    
    public func getBoolValue(name: String) -> Bool {
        let item = getSettingItem(withName: name)
        return UserDefaults.standard.bool(forKey: item.name)
    }
    
    
}

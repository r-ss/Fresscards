//
//  SettingsManager.swift
//  Energram
//
//  Created by Alex Antipov on 08.01.2023.
//

import Foundation


struct SettingsItem {
    var name: SettingsNames
    var type: String
    var defaultValue: Any
}


enum SettingsNames: String, CaseIterable {
    case testParameter = "SettingsTestParameter"
    case existence = "SettingsExistence"
    
    case showDebugInfo = "SettingsShowDebugInfo"
}



struct SettingsManager {
    
    
    static let shared = SettingsManager()
    
    //    private init() { }
    
    
    private let defaults = UserDefaults.standard
    private var settings: [SettingsItem] = [
        SettingsItem(name: SettingsNames.testParameter, type: "Bool", defaultValue: true), // Used only in tests
        SettingsItem(name: SettingsNames.existence, type: "Bool", defaultValue: true), // Used to determine existence of settings and writing default values routine if not
        SettingsItem(name: SettingsNames.showDebugInfo, type: "Bool", defaultValue: false),
    ]
    
    
    private init(){
        //print("> SettingsManager's privete Init")
        if UserDefaults.standard.object(forKey: "SettingsExistence") == nil {
            self.createAndSaveDefault()
            
        }
    }
    
    
    func createAndSaveDefault() {
        for item in self.settings {
            print("Writing default setting for \(item.name)")
            defaults.set(item.defaultValue, forKey: item.name.rawValue)
        }
    }
    
    private func getSettingItem(withName: SettingsNames) -> SettingsItem {
        let idx = self.settings.firstIndex(where: { $0.name == withName })!
        return self.settings[idx]
    }
    
    
    public func getValue(name: SettingsNames) -> Any {
        let item = getSettingItem(withName: name)
        switch item.type {
        case "Bool":
            return UserDefaults.standard.bool(forKey: item.name.rawValue)
        case "Integer":
            return UserDefaults.standard.integer(forKey: item.name.rawValue)
        case "Double":
            return UserDefaults.standard.double(forKey: item.name.rawValue)
        default:
            // in other cases we assume String
            return UserDefaults.standard.string(forKey: item.name.rawValue)!
        }
    }
    
    public func setValue(name: SettingsNames, value: Any) {
        let item = getSettingItem(withName: name)
        defaults.set(value, forKey: item.name.rawValue)
    }
    
    public func getStringValue(name: SettingsNames) -> String {
        let item = getSettingItem(withName: name)
        if let param = UserDefaults.standard.string(forKey: item.name.rawValue) {
            return param
        } else {
            return item.defaultValue as! String
        }
        
    }
    
    public func getBoolValue(name: SettingsNames) -> Bool {
        //        print("> getBoolValue for \(name)")
        let item = getSettingItem(withName: name)
        return UserDefaults.standard.bool(forKey: item.name.rawValue)
        
        //        if let param = UserDefaults.standard.bool(forKey: item.name) {
        //            return param
        //        } else {
        //            return item.defaultValue as! Bool
        //        }
    }
    
    public func getIntegerValue(name: SettingsNames) -> Int {
        let item = getSettingItem(withName: name)
        return UserDefaults.standard.integer(forKey: item.name.rawValue)
    }
    
    public func getDoubleValue(name: SettingsNames) -> Double {
        let item = getSettingItem(withName: name)
        return UserDefaults.standard.double(forKey: item.name.rawValue)
    }
    
    
}

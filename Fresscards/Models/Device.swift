//
//  Device.swift
//  Fresscards
//
//  Created by Alex Antipov on 07.04.2023.
//

import Foundation

struct DeviceInfo: Codable {
    var name: String?
    var model: String?
    var systemName: String?
    var systemVersion: String?
    var identifier: String?
    var languageCode: String?
}

//
//  Log.swift
//  Fresscards
//
//  Created by Alex Antipov on 08.07.2022.
//

import Foundation

import os // for Logger

func log(_ s:String) {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "extension")
    
    let _ = print("----------\n🌿 \(s)")
    logger.log("\(s)")
}

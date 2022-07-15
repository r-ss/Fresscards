//
//  RandomString.swift
//  Fresscards
//
//  Created by Alex Antipov on 13.07.2022.
//

extension String {
    static func random(length: Int = 6) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        let digits = "0123456789"
        return String((0..<length).map{ _ in base.randomElement()! })
    }
}

extension String {
  func firstWordCapitalization() -> String {
      var components = self.components(separatedBy: " ")
      components[0] = components[0].capitalized
      return components.joined(separator: " ")
  }
}

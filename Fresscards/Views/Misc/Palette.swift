//
//  Palette.swift
//  Fresscards
//
//  Created by Alex Antipov on 08.07.2022.
//

import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct Palette {
    // https://www.colourlovers.com/palette/92095/Giant_Goldfish
//    static let a: Color = Color(hex: 0x69D2E7)
//    static let b: Color = Color(hex: 0xA7DBD8)
//    static let c: Color = Color(hex: 0xE0E4CC)
//    static let d: Color = Color(hex: 0xF38630)
//    static let e: Color = Color(hex: 0xFA6900)
    // https://www.colourlovers.com/palette/723615/clairedelune
    static let a: Color = Color(hex: 0x413E4A)
    static let b: Color = Color(hex: 0x73626E)
    static let c: Color = Color(hex: 0xB38184)
    static let d: Color = Color(hex: 0xF0B49E)
    static let e: Color = Color(hex: 0xF7E4BE)
    
    static let background = b
    static let cardBackground = a
    static let cardTextA = e
    static let cardTextB = e
    
    
//    struct Gray {
//        static let Light = UIColor(netHex: 0x595959)
//        static let Medium = UIColor(netHex: 0x262626)
//    }
}

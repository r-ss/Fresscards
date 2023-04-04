//
//  Fonts.swift
//  Energram
//
//  Created by Alex Antipov on 23.01.2023.
//

import SwiftUI

// https://stackoverflow.com/questions/58842643/change-default-system-font-in-swiftui

extension Font {
//    static let headlineCustom = Font.custom("ArgentumSans-Bold", size: 32)
    static let headlineCustom = Font.custom("ArgentumSans-Medium", size: 28)
    static let regularCustom = Font.custom("ArgentumSans-Regular", size: 16)
}

//extension Font.TextStyle {
//    var size: CGFloat {
//        switch self {
//        case .largeTitle: return 60
//        case .title: return 48
//        case .title2: return 34
//        case .title3: return 24
//        case .headline, .body: return 18
//        case .subheadline, .callout: return 16
//        case .footnote: return 14
//        case .caption: return 12
//        case .caption2: return 10
//        @unknown default:
//            return 8
//        }
//    }
//}

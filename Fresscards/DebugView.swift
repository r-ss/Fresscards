//
//  DebugView.swift
//  Fresscards
//
//  Created by Alex Antipov on 14.07.2022.
//

import SwiftUI


struct DebugView: View {
    
    var screenWidth: String { String(format: "%.01f", UIScreen.main.bounds.width) }
    var screenHeight: String { String(format: "%.01f", UIScreen.main.bounds.height) }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Debug").font(.title)
                    ShareView()
                    Text("Screen: \(screenWidth)x\(screenHeight)")
                    VStack(spacing: 2) {
                        Rectangle().fill(Palette.a).frame(width: 200, height: 30)
                        Rectangle().fill(Palette.b).frame(width: 200, height: 30)
                        Rectangle().fill(Palette.c).frame(width: 200, height: 30)
                        Rectangle().fill(Palette.d).frame(width: 200, height: 30)
                        Rectangle().fill(Palette.e).frame(width: 200, height: 30)
                    }
                    Text("RAW JSON:")
                    RawJsonView()
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
        }}
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}

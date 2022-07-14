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
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 6) {
                ShareView()
                Text("Debug")
                Text("Screen: \(screenWidth)x\(screenHeight)")
                Group {
                    Rectangle().fill(Palette.a).frame(width: 200, height: 30)
                    Rectangle().fill(Palette.b).frame(width: 200, height: 30)
                    Rectangle().fill(Palette.c).frame(width: 200, height: 30)
                    Rectangle().fill(Palette.d).frame(width: 200, height: 30)
                    Rectangle().fill(Palette.e).frame(width: 200, height: 30)
                }
                Text("RAW JSON:")
                RawJsonView()
            }.padding()
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Debug")
        Text(String.random(length: 256)).font(.system(size: 12)).padding()
    }
}

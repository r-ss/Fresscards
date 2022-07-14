//
//  DebugView.swift
//  Fresscards
//
//  Created by Alex Antipov on 14.07.2022.
//

import SwiftUI

struct DebugView: View {
    
    var body: some View {
        VStack {
            ShareView().padding()
            Text("Debug")
            Rectangle().fill(Palette.a).frame(width: 200, height: 30)
            Rectangle().fill(Palette.b).frame(width: 200, height: 30)
            Rectangle().fill(Palette.c).frame(width: 200, height: 30)
            Rectangle().fill(Palette.d).frame(width: 200, height: 30)
            Rectangle().fill(Palette.e).frame(width: 200, height: 30)
            Divider()
            Text("RAW JSON:")
            RawJsonView()
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Debug")
        Text(String.random(length: 256)).font(.system(size: 12)).padding()
    }
}

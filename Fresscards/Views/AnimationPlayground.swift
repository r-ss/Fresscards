//
//  AnimationPlayground.swift
//  Energram
//
//  Created by Alex Antipov on 07.03.2023.
//

import SwiftUI

struct AnimationPlayground: View {
    
    @State private var start: Bool = false
    
    var body: some View {
        
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(Font.system(size: 50))
                .offset(x: start ? 12 : 0)
                .padding()
            
            Button("Shake") {
                start = true
                withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                    start = false
                }
            }
        }
    }
}

struct AnimationPlayground_Previews: PreviewProvider {
    static var previews: some View {
        AnimationPlayground()
    }
}

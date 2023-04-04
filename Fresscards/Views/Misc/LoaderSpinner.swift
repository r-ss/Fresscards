//
//  LoaderSpinner.swift
//  Energram
//
//  Created by Alex Antipov on 18.02.2023.
//

import SwiftUI

struct LoaderSpinner_Previews: PreviewProvider {
    static var previews: some View {
        LoaderSpinner()
    }
}
    
struct LoaderSpinner: View {
    var tintColor: Color = Palette.a
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .scaleEffect(scaleSize, anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
            Spacer()
        }
    }
}

//
//  CardDummy.swift
//  Fresscards
//
//  Created by Alex Antipov on 15.07.2022.
//

import SwiftUI

struct CardDummy: View {
    
    @State var geometryWidth: CGFloat = 0.0 // sets on appear and used in judjeGesture()
    @State private var centerLocation: CGPoint = CGPoint(x: 0, y: 0) // used in dragJudge if threshhold not reached
    
    @State private var location: CGPoint = CGPoint(x: 0, y: 0)
    
    
    func moveToCenterOnAppear(_ geometry: GeometryProxy){
        self.geometryWidth = geometry.size.width
        let x = geometry.size.width / 2
        let y = geometry.size.height / 2 - (geometry.size.height / 10)
        self.centerLocation = CGPoint(x:x, y:y)
        self.location = CGPoint(x:x, y:y)
    }
    
    func getTileWidth(_ geometry: GeometryProxy) -> CGFloat {
        max(geometry.size.width - 20.0, 0.0) // preventing negative values
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 20)
                .fill(Palette.cardBackground)
                .frame(width: getTileWidth(geometry), height: getTileWidth(geometry))
                .shadow(radius: 7)
                .onAppear { self.moveToCenterOnAppear(geometry) }
                .offset(x:0,y:15)
                .position(location)
        } // GeometryReader
    }
}

struct CardDummy_Previews: PreviewProvider {
    static var previews: some View {
        CardDummy()
    }
}



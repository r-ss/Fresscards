//
//  CardRow.swift
//  Fresscards
//
//  Created by Alex Antipov on 05.07.2022.
//

import SwiftUI

struct CardRow: View {
    
    let settingsManager = SettingsManager()
    var card: Card
    
    var aOptionallyCapitalized: String {
        settingsManager.getBoolValue(name: "AutoCapitalization") ? card.a.firstWordCapitalization() : card.a
    }
    
    var bOptionallyCapitalized: String {
        settingsManager.getBoolValue(name: "AutoCapitalization") ? card.b.firstWordCapitalization() : card.b
    }

    var body: some View {
            HStack(spacing: 0) {
                
                Group {
                    Text(aOptionallyCapitalized).font(.system(size: 16))
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Group {
                    Text(bOptionallyCapitalized).font(.system(size: 16))
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                
                Spacer()
                if let color = card.difficultyColor {
                    Circle()
                        .fill(color)
                        .frame(width: 10, height: 10)
                } else {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .opacity(0)
                }
                
            }.padding()
        }
}

struct CardRow_Previews: PreviewProvider {
    static var cards = jsonData().cards
    static var previews: some View {
        Group {
            CardRow(card: cards[0])
            CardRow(card: cards[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

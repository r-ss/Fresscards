//
//  EasyHardButtons.swift
//  Fresscards
//
//  Created by Alex Antipov on 15.07.2022.
//

import SwiftUI

protocol EasyHardButtonsHandler {
    func reactionHandle(easy: Bool)
}


struct EasyHardButtons: View {
    
    var reactionSubscriber: EasyHardButtonsHandler?
    
    var body: some View {
        HStack {
            
//            ReactionButton(text: "Easy", image: "tray.full")
            
            Button(action: {
                log("Easy tapped!")
//                NotificationCenter.default.post(name: Notification.Name("ReactionButtonPressedEasy"), object: nil)
                reactionSubscriber?.reactionHandle(easy: true)
            }) {
                HStack {
                    Image(systemName: "e.square")
                        .font(.none)
                    Text("Easy")
                        .fontWeight(.semibold)
                        .font(.none)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(12)
            }
            
            Button(action: {
                log("Hard tapped!")
//                NotificationCenter.default.post(name: Notification.Name("ReactionButtonPressedHard"), object: nil)
                reactionSubscriber?.reactionHandle(easy: false)
            }) {
                HStack {
                    Image(systemName: "h.square")
                        .font(.none)
                    Text("Hard")
                        .fontWeight(.semibold)
                        .font(.none)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(12)
            }
            
            
//            RoundedRectangle(cornerRadius: 8)
//                .fill(Palette.d)
//                .frame(
//                    width: 140,
//                    height: 50
//                )
        }
    }
}

struct EasyHardButtons_Previews: PreviewProvider {
    static var previews: some View {
        EasyHardButtons()
    }
}

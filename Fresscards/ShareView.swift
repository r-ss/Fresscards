//
//  ShareView.swift
//  Fresscards
//
//  Created by Alex Antipov on 11.07.2022.
//

import SwiftUI

struct ShareView: View {
    
    @State private var showingExporter = false
    
    private func actionSheet() {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // Initializing the url for the location where we store our data in filemanager
        
        let jsonURL = documentDirectory.appendingPathComponent("exported_cards").appendingPathExtension("json")
    //    let file = Bundle.load("initial_cards")
        
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        
//        UIActivityCategoryShare
        // https://nshipster.com/uiactivityviewcontroller/
        
        let activityVC = UIActivityViewController(
                activityItems: [jsonURL],
                applicationActivities: nil
        )
            keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    
    var body: some View {
        
        Button("Export words database", action: actionSheet)
        .padding()
        
    }
    
    
    
}

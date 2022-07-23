//
//  Settings.swift
//  Fresscards
//
//  Created by Alex Antipov on 14.07.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var jsonData: jsonData
    
    let settingsManager = SettingsManager()
    
    @State private var toggleAutoCapitalization = false
    
    @State private var deleteAllCardsConfirmationShown = false
    
    func readSettings() {
        self.toggleAutoCapitalization = settingsManager.getBoolValue(name: "AutoCapitalization")
    }
    
    func addBakedCards() {
        let firstRun = FirstRunSetup()
        let cards: [Card] = firstRun.loadBakedCards()
        jsonData.cards += cards
        jsonData.saveJSON()
    }
    func removeBakedCards() {
        let userCards = jsonData.cards.filter { card in
            (card.origin == .user)
        }
        jsonData.cards = userCards
        jsonData.saveJSON()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 15) {
                Text("Settings").font(.title).padding(.bottom)
                Button("Delete all cards", action: { self.deleteAllCardsConfirmationShown = true }).foregroundColor(.red)
                Button("Add baked cards", action: { self.addBakedCards() })
                Button("Remove baked cards", action: { self.removeBakedCards() })
                //            Text(String(settingsManager.getBoolValue(name: "AutoCapitalization")))
                Toggle("Auto Capitalization", isOn: $toggleAutoCapitalization)
                    .onChange(of: toggleAutoCapitalization) { value in
                        settingsManager.setValue(name: "AutoCapitalization", value: toggleAutoCapitalization)
                    }
            }
            .onAppear { self.readSettings() }
            .padding()
            .confirmationDialog(
                "Are you sure?",
                isPresented: $deleteAllCardsConfirmationShown
            ) {
                Button("Delete all cards?", role: .destructive) {
                    log("Removing all card")
                    // logic
                    jsonData.removeAllCards()
                }
            } message: {
                Text("This action cannot be undone")
            }
            .frame(width: geometry.size.width, alignment: .leading)
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

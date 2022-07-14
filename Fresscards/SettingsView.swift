//
//  Settings.swift
//  Fresscards
//
//  Created by Alex Antipov on 14.07.2022.
//

import SwiftUI

struct SettingsView: View {
    
    let settingsManager = SettingsManager()
    
    @State private var toggleAutoCapitalization = false
    
    func readSettings() {
        self.toggleAutoCapitalization = settingsManager.getBoolValue(name: "AutoCapitalization")
    }
    
    var body: some View {
        VStack {
            Text("Settings")
//            Text(String(settingsManager.getBoolValue(name: "AutoCapitalization")))
            Toggle("Auto Capitalization", isOn: $toggleAutoCapitalization)
                .onChange(of: toggleAutoCapitalization) { value in
                    settingsManager.setValue(name: "AutoCapitalization", value: toggleAutoCapitalization)
                }
        }
        .onAppear { self.readSettings() }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text(String.random(length: 256)).font(.system(size: 12)).padding()
    }
}

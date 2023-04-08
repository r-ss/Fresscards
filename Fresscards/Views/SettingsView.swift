//
//  SettingsView.swift
//  Energram
//
//  Created by Alex Antipov on 08.01.2023.
//

import Foundation

import SwiftUI





struct SettingsView: View {
    
    /// Settings
    @State private var showDebugInfo: Bool = false
    
    @AppStorage("generations_used") var generationsUsed: Int = 0
    
//    @ObservedObject var currency: Currency
    
//    @State private var identifier: String = "unknown"
    
    
    private func readSettings() {
        self.showDebugInfo = SettingsManager.shared.getBoolValue(name: SettingsNames.showDebugInfo)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 15) {
                Text("Settings").font(.headlineCustom).padding(.bottom)
                
//                Text("Device Identifier: \(identifier)")
                
                //Text("Currency: \(currency.symbol)")
                
                /// COUNTRY
//                Text("Select a country:").font(.regularCustom)
//                Picker("Select a country", selection: $countryPickerSelection) {
//                    ForEach(countriesReadable, id: \.self) {
//                        Text($0).font(.regularCustom)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .onChange(of: countryPickerSelection) { countryReadable in
//                    //print("Picked country: \(countryReadable)")
//                    changeCountry(readable: countryReadable)
//                }
                
//                /// CURRENCY
//                if countryPickerSelection == "Czech Republic" {
//                    Picker("Select a currency", selection: $currency.selectedCurrency) {
//
//                        ForEach(SelectedCurrency.allCases, id: \.self) { selection in
//                            Text(selection.tag)//.tag(flavor)
//                        }
//
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                }
//
//                /// RATES
//                if currency.selectedCurrency == .czk {
//                    Text("1 EUR = \(currency.rate) \(currency.symbol)")
//                }
                
                /// RESERVED POWER
//                Group{
//                    Text("Your Reserved Power (Watts):")
//                    TextField("Reserved Power:", value: $userReservedPower, formatter: NumberFormatter())
//                        .onSubmit {
//                            submitReservedPower()
//                        }.font(.headlineCustom)
//                        .padding(3)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                }
//
                /// DEBUG
                if Config.enableDebugUI {
                    Group {
                        Toggle("Show Debug Info", isOn: $showDebugInfo)
                            .onChange(of: showDebugInfo) { value in
                                showDebugInfo.toggle()
                                SettingsManager.shared.setValue(name: SettingsNames.showDebugInfo, value: showDebugInfo)
                            }.font(.regularCustom)
                        if showDebugInfo {
                            DebugView()
                        }
                    }
                }
                
                
//                    .background(.red)
                HStack(alignment: .lastTextBaseline, spacing:5){
                    Text("Generations:")
                    Text("\(generationsUsed)").font(.system(size: 20))
                    
                }
                Divider()
                
                StoreView()
                    .padding(0)
            }
            .onAppear {
                self.readSettings()
            
            }
            .padding()
            .frame(width: geometry.size.width, alignment: .leading)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

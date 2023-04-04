//
//  ContentView.swift
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI



struct ContentView: View {
    
    //    @State private var uuidLasttDayChart = UUID()
    //    @State private var uuidLasttDayJson = UUID()
    //    @State private var uuidDebug = UUID()
    
    
    //@StateObject var priceService = PriceService()
//    @StateObject var dailyPlan = DailyPlan()
    
    

    var body: some View {
        VStack {
            // GenerateView()
            TabView {

                GenerateView()
                    .tabItem {
                        Label("Generator", systemImage: "brain")
                    }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.2.fill")
                    }
                
                StoreView()
                    .tabItem {
                        Label("Store", systemImage: "gearshape.2.fill")
                    }

            }
        }
        .background(Palette.background)
        .onAppear {
            //userAuthState.checkAuth()
        }
            
            //self.country_code = SettingsManager.shared.getStringValue(name: "CountryCode")
            
            // At launch, we send 2 requests to get initial data from API server to make our calculations possible
            //self.applianceService.fetchAppliancesData()
            //self.priceService.fetchData(for_country: country_code)
//        }
        //.environmentObject(applianceService)
//        .environmentObject(dailyPlan)
        //.environmentObject(currency)
        //.environmentObject(userAuthState)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    //static var priceService = PriceService()
    //static var applianceService = ApplianceService()
    
    static var previews: some View {
        ContentView()//.environmentObject(priceService).onAppear {
            //self.priceService.fetchMultipleDaysData(for_country: "es")
        //}.environmentObject(applianceService).onAppear {
            //self.applianceService.fetchAppliancesData()
        //}
    }
}

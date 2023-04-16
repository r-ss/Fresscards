//
//  ContentView.swift
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI



enum TabSelection {
    case generator
    case savedCards
    case settings
}

struct ContentView: View {
    
    //    @State private var uuidLasttDayChart = UUID()
    //    @State private var uuidLasttDayJson = UUID()
    //    @State private var uuidDebug = UUID()
    
    @State private var selectedTab: TabSelection = .generator
    
    
    //@StateObject var priceService = PriceService()
//    @StateObject var dailyPlan = DailyPlan()
    
    public func changeTab(to: TabSelection) {
//        print("changing tab programmatically")
        if self.selectedTab != to {
            self.selectedTab = to
        }
    }
    
    @State private var cardSaveVisualFeedback: Bool = false
    
    
    
    

    var body: some View {
        VStack {
            // GenerateView()
            
//            VStack {
//                Image(systemName: "exclamationmark.triangle")
//                    .font(Font.system(size: 50))
//                    .offset(x: start ? 12 : 0)
//                    .padding()
//
//                Button("Shake") {
//                    start = true
//                    withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
//                        start = false
//                    }
//                }
//            }
            
            
            TabView(selection: $selectedTab) {
                
                GenerateView(changeTabFunction: changeTab)
                    .tabItem {
                            
                            Label("Generator", systemImage: "brain")
                            
//                            .offset(x: cardSaveVisualFeedback ? 10 : 0)
                            
                           
                    }
                    .tag(TabSelection.generator)
                    
                    
                
                SavedCardsListView()
                    .tabItem {
                        
                        if cardSaveVisualFeedback {
                            Label("Saved cards", systemImage: "checkmark.rectangle.fill")
                        } else {
                            Label("Saved cards", systemImage: "tray.full")
                        }
                            
                            
                    }
                    .tag(TabSelection.savedCards)

                

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.2.fill")
                    }
                    .tag(TabSelection.settings)
                
//                StoreView()
//                    .tabItem {
//                        Label("Store", systemImage: "gearshape.2.fill")
//                    }

            }
        }
        .background(Palette.background)
        .onAppear {
            //userAuthState.checkAuth()
            
            NotificationCenter.simple(name: .cardSavedFromGenerator){
//                print("Card saved notification")
                cardSaveVisualFeedback = true
//                withAnimation(.linear(duration: 1)) {
//                    cardSaveVisualFeedback = false
//                }
//
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                    cardSaveVisualFeedback = false
                    
                    
                }
                
            }
            
            
            
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

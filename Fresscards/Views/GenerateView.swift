//
//  CoreApplianceEditorView.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import SwiftUI


struct GenerateView: View {
    
    //    var durationIntProxy: Binding<Double>{
    //        // Used to bind Double for Slider to Int for data model
    //        Binding<Double>(get: {
    //            return Double( $viewModel.editingAppliance.wrappedValue.typical_duration )
    //        }, set: {
    //            //print($0.description)
    //            $viewModel.editingAppliance.wrappedValue.typical_duration = Int($0)
    //        })
    //    }
    //
    
    @AppStorage("generations_used") var generationsUsed: Int = 0
    
    @StateObject var cardsWorker = CardsWorker()
    
    @State private var generating: Bool = false
    
    @State var lang_a = "Spanish"
    @State var lang_b = "Russian"
    @State var theme = "Formula-1"
    @State var count = 10
    
    private let count_cases = [10, 15, 20]
    
    @State private var show_results_screen = false
    
    @State var resp: NeuralResponse?
    
    @State private var showAlert = false
    @State private var alertMessage: String = "Error..."
    
    var ready_cards: [NeuralResponseItem] = []
    
    let languages = ["English", "Spanish", "French", "German", "Italian", "Chinese", "Japanese", "Korean", "Arabic", "Russian"]
    
    let themes = [
        "Food", "Travel", "Business", "School", "Nature", "Hospital", "Family", "Formula-1", "Airport", "Sports", "Entertainment", "Music", "Fashion", "Finance", "Shopping", "House and Home", "Time and Calendar", "Weather and Climate", "Geography and Landmarks", "Football","Art and Design", "Religion and Spirituality", "Social Issues", "Communication and Media", "Science and Technology", "Transport", "Law and Justice", "History and Heritage", "Emotions and Feelings", "Language and Linguistics"
    ]
    
    
    private func makeAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { maingeometry in
                
                VStack(alignment: .leading, spacing: 15) {
                    Group {
                        
                        Form {
                            Section {
                                VStack(alignment: .center) {
                                    Text("Choose languages")
                                    HStack(spacing: 10){
                                        //                                        Text("From")
                                        Picker(selection: $lang_a, label: Text("A")) {
                                            ForEach(languages, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .labelsHidden()
                                        .frame(minWidth: 120)
                                        //                                        Text("To")"
                                        
                                        Image(systemName: "arrow.forward")
                                        
                                        Picker(selection: $lang_b, label: Text("B")) {
                                            ForEach(languages, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .labelsHidden()
                                        .frame(minWidth: 120)
                                    }
                                }
                                
                                .frame(width: maingeometry.size.width - 80)
                                //                                .background(.red)
                            }
                            Section {
                                VStack(alignment: .center) {
                                    Text("Type any theme")
                                    TextField("Theme",
                                              text: $theme,
                                              onCommit: { Task { await generateCardsAction() } }
                                    )
                                    .submitLabel(.done)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .simultaneousGesture(TapGesture().onEnded {
                                        theme = ""
                                    })
                                    Button() {
                                        let candidate: String = self.themes.randomElement()!
                                        if self.theme != candidate {
                                            self.theme = candidate
                                        } else {
                                            self.theme = self.themes.randomElement()!
                                        }
                                    } label: {
                                        Label("Random Theme", systemImage: "dice")
                                    }
                                }
                                .frame(width: maingeometry.size.width - 80)
                                //                                .background(.red)
                                
                                
                            }
                            
                            Section {
                                VStack(alignment: .center) {
                                    Text("How many cards")
                                    Picker("Select cards count", selection: $count) {
                                        ForEach(count_cases, id: \.self) { selection in
                                            Text("\(selection)")
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                                .frame(width: maingeometry.size.width - 80)
                                //                                .background(.red)
                                
                            }
                            
                            Section {
                                
                                Button() {
                                    Task { await generateCardsAction() }
                                } label: {
                                    if generating {
                                        LoaderSpinner()
                                    } else {
                                        Label("Generate", systemImage: "brain")
                                    }
                                }
                            }
                            
                            Section {
                                if generationsUsed >= 0 {
                                    PurchaseView()
                                } else {
                                    Text("Generations used: \(generationsUsed)")
                                }
                            }
                            
                        }
                    }
                }
                .frame(width: maingeometry.size.width, height: maingeometry.size.height, alignment: .leading)
            }
            .navigationBarTitle("Generate flashcards")
            
            
            NavigationLink(destination: Tiles(cardsWorker: cardsWorker), isActive: $show_results_screen) { EmptyView() }
            
        }
        .onAppear {
            self.theme = self.themes.randomElement()!
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
        .environmentObject(cardsWorker)
    }
    
    private func generateCardsAction() async {
        generating = true
        Task(priority: .background) {
            
            let req_construct = NeuralRequest(lang_a: lang_a, lang_b: lang_b, theme: theme, count: count)
            
            
            let response = await FresscardsService().generateCards(request: req_construct)
            switch response {
            case .success(let result):
                //                print(result)
                resp = result
                //                    dailyPlan.priceReceived(price: result)
                //                    pricesLoading = false
                //                if let rs = result {
                cardsWorker.resultReceived(resp!)
                //                }
                generating = false
                show_results_screen = true
                generationsUsed = generationsUsed + 1
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                //                    pricesLoading = false
                generating = false
                makeAlert(message: error.customMessage)
            }
        }
    }
    
    
}

struct GenerateView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateView(resp: NeuralResponse.mocked.response1)
    }
}

//extension Binding {
//
//    static func convert<TInt, TFloat>(from intBinding: Binding<TInt>) -> Binding<TFloat>
//    where TInt:   BinaryInteger,
//          TFloat: BinaryFloatingPoint{
//
//              Binding<TFloat> (
//                get: { TFloat(intBinding.wrappedValue) },
//                set: { intBinding.wrappedValue = TInt($0) }
//              )
//          }
//
//    static func convert<TFloat, TInt>(from floatBinding: Binding<TFloat>) -> Binding<TInt>
//    where TFloat: BinaryFloatingPoint,
//          TInt:   BinaryInteger {
//
//              Binding<TInt> (
//                get: { TInt(floatBinding.wrappedValue) },
//                set: { floatBinding.wrappedValue = TFloat($0) }
//              )
//          }
//}


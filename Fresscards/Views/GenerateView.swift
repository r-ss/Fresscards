//
//  CoreApplianceEditorView.swift
//  Energram
//
//  Created by Alex Antipov on 04.03.2023.
//

import SwiftUI

import Firebase


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
    
    @State var lang_a: String = "Spanish"
    @State var lang_b: String = "English"
    
    
    @AppStorage("lang_a_appstorage") var lang_a_appstorage: String = "Spanish"
    @AppStorage("lang_b_appstorage") var lang_b_appstorage: String = "English"
    
    @State var theme = "Formula-1"
    @State var count = 10
    
    private let count_cases = [10, 15, 20]
    
    @State private var show_results_screen = false
    
    @State var resp: NeuralResponse?
    
    @State private var showAlert = false
    @State private var showPaywallAlert = false
    @State private var alertMessage: String = "Error..."
    
    @State private var isPurchased: Bool = true
    
    var ready_cards: [NeuralResponseItem] = []
    
    var changeTabFunction: (_ to: TabSelection) -> Void
    
    var languages: [String] {
        
        var bin = Config.baseLanguages
        
        if isPurchased {
            bin += Config.additionalLanguages
        }
        
        return bin
    }
    
    let themes = [
        "Food", "Travel", "Business", "School", "Nature", "Hospital", "Family", "Formula-1", "Airport", "Sports", "Entertainment", "Music", "Fashion", "Finance", "Shopping", "House", "Time and Calendar", "Weather and Climate", "Football", "Art and Design", "Social Issues", "Communication and Media", "Science and Technology", "Transport", "Law and Justice", "History and Heritage", "Emotions and Feelings", "Language and Linguistics"
    ]
    
    let themes_ru = ["Еда", "Путешествия", "Бизнес", "Школа", "Природа", "Больница", "Семья", "Формула-1", "Аэропорт", "Спорт", "Развлечения", "Музыка", "Мода", "Финансы", "Шопинг", "Дом", "Время и календарь", "Погода и климат", "Футбол", "Искусство и дизайн", "Социальные вопросы", "Коммуникация и СМИ", "Наука и техника", "Транспорт", "Закон и правосудие", "История и наследие", "Эмоции и чувства", "Язык и лингвистика"]
    
    let themes_es = ["Comida", "Viajes", "Negocios", "Escuela", "Naturaleza", "Hospital", "Familia", "Fórmula-1", "Aeropuerto", "Deportes", "Entretenimiento", "Música", "Moda", "Finanzas", "Compras", "Casa", "Tiempo y calendario", "Tiempo y clima", "Fútbol", "Arte y diseño", "Cuestiones sociales", "Comunicación y medios de comunicación", "Ciencia y tecnología", "Transporte", "Derecho y justicia", "Historia y patrimonio", "Emociones y sentimientos", "Lengua y lingüística"]
    
    private func readPurchasesFromDefaults(){
        
        self.isPurchased = UserDefaults.standard.bool(forKey: "unlimited_generator")
        //        print(isPurchased)
    }
    
    private func setRandomTheme(){
        
        let locale = Locale.current.language.languageCode?.identifier ?? "en"
        var t = self.themes
        
        if locale == "ru" {
            t = self.themes_ru
        }
        if locale == "es" {
            t = self.themes_es
        }
        
        let candidate: String = t.randomElement()!
        if self.theme != candidate {
            self.theme = candidate
        } else {
            self.theme = t.randomElement()!
        }
    }
    
    
    private func makeAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    
    var body: some View {
        NavigationStack {
            
            GeometryReader { maingeometry in
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    //                    Button("Switch View") {
                    //                        changeTabFunction(.settings)
                    //                            }
                    //
                    //                                        Text(isPurchased ? "yes" : "no")
                    //                    Text("Generations used: \(generationsUsed)")
                    //                    Text("show_results_screen: \( String(isPurchased))")
                    
                    
                    Group {
                        
                        Form {
                            Section {
                                VStack(alignment: .center) {
                                    Text("Choose languages")
                                    HStack(spacing: 10){
                                        Picker(selection: $lang_a, label: Text("A")) {
                                            ForEach(languages, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .labelsHidden()
                                        .frame(minWidth: 120)
                                        .onChange(of: lang_a) { lang in
                                            print("lang a: \(lang)")
                                            lang_a_appstorage = lang_a
                                        }
                                        
                                        // Button reversing languages
                                        Button() {
                                            let temp_a = lang_a
                                            let temp_b = lang_b
                                            
                                            lang_a = temp_b
                                            lang_b = temp_a
                                            
                                            lang_a_appstorage = lang_a
                                            lang_b_appstorage = lang_b
                                        } label: {
                                            Image(systemName: "arrow.forward")
                                                .foregroundColor(.primary)
                                        }
                                        
                                        Picker(selection: $lang_b, label: Text("B")) {
                                            ForEach(languages, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .labelsHidden()
                                        .frame(minWidth: 120)
                                        .onChange(of: lang_b) { lang in
                                            print("lang b: \(lang)")
                                            lang_b_appstorage = lang_b
                                        }
                                    }
                                }
                                
                                .frame(width: max(maingeometry.size.width - 80, 0))
                            }
                            
                            
                            Section {
                                VStack(alignment: .center) {
                                    Text("Type any theme")
                                    TextField("Theme",
                                              text: $theme,
                                              onCommit: {
                                        //                                        self.endTextEditing()
                                        Task { await generateCardsAction() }
                                    }
                                    )
                                    .submitLabel(.done)
                                    .disableAutocorrection(true)
                                    .simultaneousGesture(TapGesture().onEnded {
                                        theme = ""
                                    })
                                    
                                    Button() {
                                        
                                        //self.endTextEditing()
                                        self.setRandomTheme()
                                    } label: {
                                        Label("Random Theme", systemImage: "dice")
                                    }
                                }
                                .frame(width: max(maingeometry.size.width - 80, 0))
                                
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
                                .frame(width: max(maingeometry.size.width - 80, 0))
                                
                            }
                            
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
                    }
                }
                .frame(width: maingeometry.size.width, height: maingeometry.size.height, alignment: .leading)
            }
            .navigationDestination(isPresented: $show_results_screen) {
                CardsView(cardsWorker: cardsWorker)
                
            }
            .navigationTitle("Generate flashcards")
            .onAppear {
                self.isPurchased = UserDefaults.standard.bool(forKey: "unlimited_generator")
                lang_a = lang_a_appstorage
                lang_b = lang_b_appstorage
            }
            //            .simultaneousGesture(LongPressGesture().onEnded {
            //
            //                              self.endTextEditing()
            //                        })
            
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert(alertMessage, isPresented: $showPaywallAlert) {
            Button("OK", role: .cancel) {
                changeTabFunction(.settings) // going to Settings tab with a in-app purchase
            }
        }
        .onAppear {
            self.setRandomTheme()
            
            // Google Analytics
            Analytics.logEvent(AnalyticsEventScreenView,
                               parameters: [AnalyticsParameterScreenName: "\(GenerateView.self)",
                                           AnalyticsParameterScreenClass: "\(GenerateView.self)"])
            
            
        }
        .environmentObject(cardsWorker)
        //            .simultaneousGesture(
        //                // Hide the keyboard on scroll
        //                DragGesture().onChanged { _ in
        //                    UIApplication.shared.sendAction(
        //                        #selector(UIResponder.resignFirstResponder),
        //                        to: nil,
        //                        from: nil,
        //                        for: nil
        //                    )
        //                }
        //            )
        
        
        
        
    }
    
    private func generateCardsAction() async {
        
        self.readPurchasesFromDefaults()
        
        if generationsUsed >= Config.allowedGenerationsBeforePaywall && !isPurchased {
            alertMessage = "We are paying costs for cards generations, please support us with one-time purchase to use generator without limit."
            showPaywallAlert = true
            return()
        }
        
        if theme == "" {
            makeAlert(message: "Please enter theme. Any you can imagine!")
            return()
        }
        
        let device = DeviceInfo(
            name: UIDevice.current.name,
            model: UIDevice.current.model,
            systemName: UIDevice.current.systemName,
            systemVersion: UIDevice.current.systemVersion,
            identifier: UIDevice.current.identifierForVendor?.uuidString ?? "unknown",
            languageCode: Locale.current.language.languageCode?.identifier ?? "unknown"
        )
        
        Task(priority: .background) {
            // Google Analytics
            Analytics.logEvent("generator_request", parameters: ["lang_a": "\(lang_a)", "lang_b": "\(lang_b)", "theme": "\(theme)", "cards_count": "\(count)"])
        }
        
        generating = true
        Task(priority: .background) {
            
            
            
            let req_construct = NeuralRequest(
                lang_a: lang_a,
                lang_b: lang_b,
                theme: theme,
                count: count,
                device: device
            )
            
            let response = await FresscardsService().generateCards(request: req_construct)
            switch response {
            case .success(let result):
                resp = result
                cardsWorker.resultReceived(resp!)
                generating = false
                show_results_screen = true
                generationsUsed = generationsUsed + 1
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                generating = false
                makeAlert(message: error.customMessage)
            }
        }
    }
}

struct GenerateView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateView(resp: NeuralResponse.mocked.response1, changeTabFunction: { _ in
            
        })
    }
}


//extension View {
//    func endTextEditing() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
//                                        to: nil, from: nil, for: nil)
//    }
//}

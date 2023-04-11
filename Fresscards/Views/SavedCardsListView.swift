//
//  SavedCardsListView.swift
//  Fresscards
//
//  Created by Alex Antipov on 09.04.2023.
//

import SwiftUI

struct SavedCardsListView: View {
    
    @ObservedObject var viewModel = CardsListViewModel()
    
    @State private var showingCardAddView = false
    
    @State private var selectedCard: Card?
    
    //    init(dataManager: DataManager = DataManager.shared) {
    //        self.viewModel = CardsListViewModel(card: nil, dataManager: dataManager)
    //    }
    func deleteRow(at offsets: IndexSet) {
        viewModel.delete(at: offsets)
    }
    
    private let lpad: CGFloat = 18 // list padding
    
    @StateObject var cardsWorker = CardsWorker()
    @State private var show_as_cards_screen = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { list_geometry in
                VStack {
                    //                    Text("Saved Cards").font(.headline).padding(.bottom)
                    
                    if viewModel.cards.count == 0 {
                        
                        Text("No cards saved")
                            .foregroundColor(.secondary)
                            .padding(.leading, lpad)
                        
                    } else {
                        
                        //                        if let dpCards = viewModel.cards {
                        List {
                            ForEach(viewModel.cards, id: \.self) { item in
                                
                                    HStack(spacing: 3*2){
                                        Text(item.side_a)
                                            .frame(width: (list_geometry.size.width - lpad*2) / 2 - 3, alignment: .leading)
                                        Text(item.side_b)
                                            .frame(width: (list_geometry.size.width - lpad*2) / 2 - 3, alignment: .leading)
                                        //                                                    .background(.green)
                                }.frame(width: (list_geometry.size.width - lpad*2), height: 20)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedCard = item
                                    }
                                    
//                                    .listRowSeparator(.hidden)
                                    
                                    
                            }
                            
                            .onDelete(perform: deleteRow)
                            .padding(.leading, lpad)
                            .padding(.trailing, lpad)
                                
                            
                            
                        }
                        .listStyle(PlainListStyle())
                        


                        
                        //                        }
                    }
                }
                .navigationTitle("Saved Cards")
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingCardAddView = true
                        } label: {
                            HStack {
                                Text("Add")
                                Image(systemName: "plus")
                            }
                        }
                    }
                    
                    if viewModel.cards.count > 2 {
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                cardsWorker.cardsFill(viewModel.cards)
                                show_as_cards_screen = true
                            } label: {
                                HStack {
                                    Text("Show flashcards")
                                    //                                Image(systemName: "plus")
                                }
                            }
                        }
                    }
                }
                
            }//.padding()
            .sheet(isPresented: $showingCardAddView) {
                CardAdd(card: nil, createMode: true)
                    .presentationDetents([.fraction(0.35)])
            }
            .sheet(item: $selectedCard) { selected in
                CardAdd(card: selected)
                    .presentationDetents([.fraction(0.35)])
            }
            .navigationDestination(isPresented: $show_as_cards_screen) {
                CardsView(cardsWorker: cardsWorker, savingDisabled: true)
                
            }
        }
    }
}

struct SavedCardsListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedCardsListView(viewModel: CardsListViewModel(dataManager: .preview))
    }
}

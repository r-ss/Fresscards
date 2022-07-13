//
//  CoreDataPlayground.swift
//  Fresscards
//
//  Created by Alex Antipov on 12.07.2022.
//

import SwiftUI
import CoreData

struct CoreDataPlayground: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest(entity: AACard.entity(), sortDescriptors: [])
    var aacards: FetchedResults<AACard>
    
    func atata(){
        log("atata")
//        guard self.tableNumber != "" else {return}
        let newOrder = AACard(context: viewContext)
        newOrder.a = "a2"
        newOrder.b = "bb"
        newOrder.id = UUID()
        do {
            try viewContext.save()
            log("Order saved.")
//            presentationMode.wrappedValue.dismiss()
        } catch {
            log(error.localizedDescription)
        }
    }


    var body: some View {
        
        List {
            ForEach(aacards) { card in
                    VStack(alignment: .leading) {
                        Text(card.a)
                    }
            }
        }
            .listStyle(PlainListStyle())


        Button("CoreDataPlayground", action: { self.atata() })
    }
}

struct CoreDataPlayground_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataPlayground()
    }
}

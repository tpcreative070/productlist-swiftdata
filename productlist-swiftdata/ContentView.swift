//
//  ContentView.swift
//  productlist-swiftdata
//
//  Created by phong on 31/5/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingItemsheet = false
    
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Item> {$0.value > 10}, sort: \Item.date) private var items: [Item]
    @State private var itemToEdit : Item?
    

    var body: some View {
        NavigationStack {
            List {
                ForEach(items){ item in
                    ItemCell(item: item)
                        .onTapGesture {
                            itemToEdit = item
                        }
                }.onDelete(perform: { indexSet in
                    for index in indexSet {
                        context.delete(items[index])
                    }
                })
            }
            .navigationTitle("Item")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemsheet) {
                AddItemSheet()
            }
            .sheet(item: $itemToEdit) { item in
                UpdateItemSheet(item: item)
            }
            .toolbar {
                if !items.isEmpty {
                    Button("Add Item",systemImage: "plus"){
                        isShowingItemsheet = true
                    }
                }
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Item",systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding item to see your list")
                    }, actions: {
                        Button("Add Item"){
                            isShowingItemsheet = true
                        }
                    })
                    .offset(y:-60)
                }
            }
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}



struct ItemCell : View {
    let item : Item
    var body: some View {
        HStack {
            Text(item.date,format: .dateTime.month(.abbreviated).day())
                .frame(width: 70,alignment: .leading)
            Text(item.name)
            Text(item.value,format: .currency(code: "USD"))
        }
    }
}

struct AddItemSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value : Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Item Name", text: $name)
                DatePicker("Date", selection: $date,displayedComponents: .date)
                TextField("Value", value:  $value,format: .currency(code: "USD")).keyboardType(.decimalPad)
            }
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {dismiss()}
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save"){
                        let item = Item(name: name, date: date, value: value)
                        context.insert(item)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UpdateItemSheet  : View{

    @Environment(\.dismiss) private var dismiss
    @Bindable var item : Item
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Item Name", text: $item.name)
                DatePicker("Date", selection: $item.date,displayedComponents: .date)
                TextField("Value", value:  $item.value,format: .currency(code: "USD")).keyboardType(.decimalPad)
            }
            .navigationTitle("Update Item")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done"){
                        dismiss()
                    }
                }
            }
        }
    }
}

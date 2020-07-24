//
//  ContentView.swift
//  iExpense
//
//  Created by DeNNiO   G on 17.05.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {

    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
                print("saved")
            }
        }
    }
    init() {
        if let itemsaved = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: itemsaved) {
                self.items = decoded
                return
            }
        }
        print("empty")
        self.items = []
    }
    
}



struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
   
    
    //исправление бага с неработающей кнопкой после возврата из доп вью
    
    @Environment(\.presentationMode) var presentationMode
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    var sum: Int {
           var some = 0
           for item in expenses.items {
            some += Int(item.amount)}
               return some
       }
  
    //разный цвет текста в зависомти от суммы
    func styledText(someItem: Int)-> some View {
        if someItem < 10 {
         return   Text("$\(someItem)")
                .foregroundColor(.blue)
        } else if someItem < 100 && someItem > 10 {
        return    Text("$\(someItem)")
            .foregroundColor(.orange)
        } else {
        return    Text("$\(someItem)")
               .foregroundColor(.red)
        }
        }

    var body: some View {
        NavigationView {
            VStack {
            List {
                ForEach(expenses.items) {
                    item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                      
                    
                        self.styledText(someItem: item.amount)
                    }
                
                }.onDelete(perform: removeItems)
            }
                Text("Total $ \(sum)")
                    .font(.headline)
            }
            .navigationBarTitle("iExpense")
        
                .navigationBarItems(leading:
                    HStack {
                    EditButton()
                    }, trailing: HStack {
                        Button(action: {
                            self.showingAddExpense = true
                        }) {
                            Image(systemName: "plus")
                                }
                        
            })
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: self.expenses)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

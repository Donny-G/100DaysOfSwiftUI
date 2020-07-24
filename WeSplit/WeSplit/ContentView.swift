//
//  ContentView.swift
//  WeSplit
//
//  Created by DeNNiO   G on 27.04.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI


//прячем клавиатуру при нажатии на любой элемент вью
extension UIView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.windows
            .first {$0.isKeyWindow}?
        .endEditing(true)
    }
}

struct ContentView: View {
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    @State private var handTips = ""
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var people: Double {
        return Double(numberOfPeople + 2)
    }
    
    var tipFromPicker: Double {
       return Double(tipPercentages[tipPercentage])
    }
    
    var tipFromTextField: Double {
        return Double(handTips) ?? 0
    }
    
    var amount: Double {
        return Double(checkAmount) ?? 0
    }
    
    var amountPer: Double {
        let amountPerPerson = totalAmount(tipFromPicker, tipFromTextField, amount: amount) / people
        return amountPerPerson
    }
    
    func totalAmount(_ tip1: Double, _ tip2: Double, amount: Double) ->Double {
         var tipValue = 0.0
               if tip2 != 0 {
                     tipValue = amount/100 * tip2
               } else {
                     tipValue = amount/100 * tip1
                       }
        let grandtotal = amount + tipValue
        return grandtotal
    }
    
    
    var body: some View {
        NavigationView {
            Form {
            Section {
                
                TextField("Amount", text: $checkAmount)
                    .keyboardType(.decimalPad)
                    
                
                
                Picker("Number of people", selection: $numberOfPeople) {
                    ForEach(2..<100) {
                        Text("\($0) people")
                    }
                }
            }
            
            Section(header: Text("How much tip do you want to leave?")) {
                Picker("Tip percentage", selection: $tipPercentage) {
                    ForEach(0 ..< tipPercentages.count) {
                        Text("\(self.tipPercentages[$0])")
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                TextField("Enter tip", text: $handTips)
                    .keyboardType(.numberPad)
            }
                
            Section(header: Text("Total amount for check with tips")) {
            Text("$\(totalAmount(tipFromPicker, tipFromTextField, amount: amount), specifier: "%.2f")")
                .foregroundColor( tipFromPicker == 0 ? .red: .blue)
            }
                    
            Section(header: Text("Total amount per person")) {
                Text("$\(amountPer, specifier: "%.2f")")
                }
                .navigationBarTitle("WeSplit")
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

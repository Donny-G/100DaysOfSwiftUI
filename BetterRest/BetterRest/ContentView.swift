//
//  ContentView.swift
//  BetterRest
//
//  Created by DeNNiO   G on 07.05.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //change color of title
    init() {
      let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    let model = SleepCalculator()
    
    func calculateBedtime()-> String {
        var alertMessage = ""
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            alertMessage = formatter.string(from: sleepTime)
        } catch {
            showingAlert = true
        }
        return alertMessage
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")){
                    HStack(spacing: 50){
                        
                        Image("alarm")
                            .resizable()
                            .frame(width: 90, height: 90, alignment: .trailing)
                        
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .scaleEffect(0.7)
                    }
                }
                    .frame(height: 80)
                    .foregroundColor(.orange)
                    .font(.headline)
                
        
                Section(header: Text("Desired amount of sleep")) {
                    HStack {
                        
                        Image("sleep")
                            .resizable()
                            .frame(width: 70, height: 70, alignment: .trailing)
                        
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%.2g") hours")
                        }
                    .accessibility(value: Text("Sleep amount is \(sleepAmount) hours"))
                    }
                }
                    .frame(height: 60)
                    .foregroundColor(.orange)
                    .font(.headline)
               
                Section(header: Text("Daily coffee intake")) {
                    
                        Picker("select coffee", selection: $coffeeAmount) {
                            ForEach(0..<20) {
                            if $0 % 3 == 0 {
                            Text("\($0)")
                                }
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(.orange)
                    
                        HStack {
                            Image("coffee")
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .trailing)
                            
                            Stepper(value: $coffeeAmount, in: 1...20) {
                                if coffeeAmount == 1 {
                                    Text("1 cup")
                                } else {
                                    Text("\(coffeeAmount) cups")
                                }
                            }
                        }
                        .foregroundColor(.orange)
                }
                    .foregroundColor(.orange)
                    .font(.headline)
                
                Section(header: Text("Your ideal bedtime is")) {
                
                    Text("\(calculateBedtime())")
                        .frame(width: 350)
                        .font(.largeTitle)
                        .scaleEffect(2)
                        .foregroundColor(.red)
                }
                    .frame(height: 40)
                    .foregroundColor(.orange)
                    .font(.headline)
                
            }
            .navigationBarTitle("BetterRest")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Sorry? there was a problem calculating your bedtime"), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

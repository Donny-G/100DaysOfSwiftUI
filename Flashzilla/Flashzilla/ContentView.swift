//
//  ContentView.swift
//  Flashzilla
//
//  Created by DeNNiO   G on 19.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import CoreHaptics

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}
struct ContentView: View {
    @State private var cards = [Card]()
     @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    //!1
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isActive = true
    
    @State private var showingEditScreen = false
    
    
    @State private var location = CGSize.zero
       @State private var locations: [Double] = [250, 300, -400, -300, 350, -400, -600, 600, 900, 450]
    @State private var alertShow = false
    
     @State private var returnWrong = true
    
    func gameOver() {
         self.location = CGSize(width: locations.randomElement() ?? 600, height: locations.randomElement() ?? -900)
        self.alertShow = true
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        if !returnWrong {
        cards.remove(at: index)
        } else {
            cards.insert(self.cards[index], at: index)
        }
        if cards.isEmpty {
            isActive = false
        }
    }
    
   
    
    func resetCards() {
        cards = [Card](repeating: Card.example, count: 5)
        timeRemaining = 10
        isActive = true
        loadData()
        location = CGSize.zero
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
           VStack {
            HStack {
            HStack {
                Text("Returning card")
                    .font(.callout)
                    .foregroundColor(.white)
            Toggle(isOn: $returnWrong) {
                Text("Persistant False")
                    .font(.callout)
            }.labelsHidden()
                .foregroundColor(.black)
            }
                .padding()
            .background(Capsule()
            .fill(Color.black)
            .opacity(0.75))
            
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
            
            )
                Spacer()
            }
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: self.cards[index]) {
                            withAnimation {self.removeCard(at: index)}
                        }
                            .stacked(at: index, in: self.cards.count)
                            //!
                            .allowsHitTesting(index == self.cards.count - 1)
                            .accessibility(hidden: index < self.cards.count - 1)
                        .offset(self.location)
                    }
                }
                    //!2
                .allowsHitTesting(timeRemaining > 0)
            
                if cards.isEmpty {
                Button("Start Again", action: resetCards)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
            }
           
                
            
            
            
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus.circle")
                        .padding()
                            .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || accessibilityEnabled {
                           VStack {
                               Spacer()
                               
                               HStack {
                                Button(action: {
                                    withAnimation {
                                        self.removeCard(at: self.cards.count - 1)
                                    }
                                    
                                }) {
                                   Image(systemName: "xmark.circle")
                                        .padding()
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                    .accessibility(label: Text("Wrong"))
                                    .accessibility(hint: Text("Mark your answer as being incorrect"))
                                   Spacer()
                                Button(action: {
                                    withAnimation { self.removeCard(at: self.cards.count - 1)
                                    }
                                }) {
                                   Image(systemName: "checkmark.circle")
                                        .padding()
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Circle())
                                }
                               .accessibility(label: Text("Correct"))
                               .accessibility(hint: Text("Mark your answer as being correct"))
                               }
                           }
                       }
        
        }
       //!1
                   .onReceive(timer) { time in
                       guard self.isActive else { return }
                       if self.timeRemaining > 0 {
                           self.timeRemaining -= 1
                       } else {
                        self.gameOver()
                        
                    }
                   }
                   .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                       self.isActive = false
                   }
                   .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    if self.cards.isEmpty == false {
                        self.isActive = true
                        }
                    }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) { EditCards()
        }
        .onAppear(perform: resetCards)
        .alert(isPresented: $alertShow) { Alert(title: Text("Game Over"), message: Text("Time is Over"), dismissButton: .default(Text("New Game"), action: {
            self.resetCards()
        }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

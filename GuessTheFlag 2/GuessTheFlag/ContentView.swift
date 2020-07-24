//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by DeNNiO   G on 02.05.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI



struct ContentView: View {
   @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var score = 0
    @State private var rotationAnimationAmount = 0.0
    @State private var opacityAmmount: Double = 1
    @State private var scaleEffectAmount: CGFloat = 1
    @State private var isOver = false
    @State private var location = CGSize.zero
    @State private var locations: [Double] = [250, 300, -400, -300, 350, -400, -600, 600, 900, 450]
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            withAnimation { self.rotationAnimationAmount += 360
                self.opacityAmmount -= 0.75
            }
            
        } else {
            scoreTitle = "Wrong, it is flag of \(countries[number])"
            score -= 1
            withAnimation {
                self.isOver.toggle()
             //   self.scaleEffectAmount -= 2
                self.location = CGSize(width: locations.randomElement() ?? 600, height: locations.randomElement() ?? -900)
                
            }
           
                self.scaleEffectAmount = 1
                self.isOver.toggle()
        
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showingScore = true
        }
    }
    
    func askQuestion() {
       
    location = CGSize.zero
      //  scaleEffectAmount = 1
      //  isOver.toggle()
        opacityAmmount = 1
        
        rotationAnimationAmount = 0.0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
        VStack(spacing: 30) {
            VStack {
            Text("Tap the flag of")
                .foregroundColor(.white)
            Text(countries[correctAnswer])
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.black)
            }
            ForEach(0 ..< 3, id: \.self) {
                id in Button(action: {
                   self.flagTapped(id)
                }) {
                    Image(self.countries[id])
                        .renderingMode(.original)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                        .shadow(color: .black, radius: 2)
                    
                }
        
                    
                    
                .opacity(id != self.correctAnswer ? self.opacityAmmount : 1)
                
                .animation(.easeInOut(duration: 2))

                .scaleEffect(self.isOver ?  self.scaleEffectAmount: 1)
                .animation(.easeOut(duration: 2))
                    
               
                .offset(self.location)
                .animation(.easeInOut(duration: 2))
                
                .rotation3DEffect(.degrees(id == self.correctAnswer ? self.rotationAnimationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
                
                
                
            }
            
            
            
            
            Text("Score: \(score)")
                .foregroundColor(.white)
                .font(.largeTitle)
            Spacer()
        }
    }
        .alert(isPresented: $showingScore) { Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
            self.askQuestion()
            })
        }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}

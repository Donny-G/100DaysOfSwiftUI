//
//  ContentView.swift
//  GeometryAndLayout
//
//  Created by DeNNiO   G on 21.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI



struct ContentView: View {
     let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical, showsIndicators: false) {
             //   HStack {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        
                        
                       Text("Row #\(index)")
                         .font(.title)
                          .frame(width: fullView.size.width)
                        .background(self.colors[index % 7])
                   /*
                       Rectangle()
                        .fill(self.colors[index % 7])
                        .frame(height: 150)
                        .rotation3DEffect(.degrees(Double(geo.frame(in: .global).maxX)), axis: (x: 0, y: 0, z: 1))
 */
                       
                            .rotation3DEffect(.degrees(Double(geo.frame(in: .global).minY - fullView.size.height / 2) / 5), axis: (x: 0, y: 1, z: 0) )
                    
                            
                   /*         .rotation3DEffect(.degrees(Double(geo.frame(in: .global).minY) / 5), axis: (x: 0, y: 1, z: 0) )
 */
                    }
                        
                    .frame(height: 45)
                }
            }
          //  .padding(.horizontal, ((fullView.size.width - 150) / 2))
        }
  //  }
   //     .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  CheckoutView.swift
//  CupCakeCorner
//
//  Created by DeNNiO   G on 31.05.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var confirmationMessage = ""
    @State private var alertMessage = ""
    @State private var showingConfirmation = false
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else { self.alertMessage = "OOPS"
        self.confirmationMessage = "Ploblem in data encoding"
        self.showingConfirmation = true
            return
        }
        guard let url = URL(string: "https://reqres.in/api/cupcakes") else {
            self.alertMessage = "OOPS"
            self.confirmationMessage = "Please call us, as we have some problems with server"
            self.showingConfirmation = true
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.alertMessage = "OOPS"
                self.confirmationMessage = "No data in response: \(error?.localizedDescription ?? "Unknown error")"
                self.showingConfirmation = true
                
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.alertMessage = "Thank you"
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            } else {
                self.alertMessage = "OOPS"
                self.confirmationMessage = "Please check your internet connection"
                self.showingConfirmation = true
            }
            
        }.resume()
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                    .resizable()
                    .scaledToFit()
                        .frame(width: geo.size.width)
                        .accessibility(hidden: true)
                    
                    Text("Your total is $\(self.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        self.placeOrder()
                    }
                .padding()
                }
            }
        }.alert(isPresented: $showingConfirmation, content: { Alert(title: Text(alertMessage), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        })
        .navigationBarTitle("Check out", displayMode: .inline)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}

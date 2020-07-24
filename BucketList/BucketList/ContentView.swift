//
//  ContentView.swift
//  BucketList
//
//  Created by DeNNiO   G on 10.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {
   
    @State private var isUnlocked = false
    @State private var errorAlert = false
    @State private var errorMessage = ""
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.errorMessage = authenticationError?.localizedDescription ?? "Unknown error"
                    }
                }
            }
        } else {
            self.errorMessage = error?.localizedDescription ?? "Unknown error"
        }
    }
    
    var body: some View {
        Group {
            if isUnlocked {
                
           UnlockedMapView()
            
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
            .padding()
                .background(Color.blue)
                .foregroundColor(.white)
            .clipShape(Capsule())
            }

        }.alert(isPresented: $errorAlert) { Alert(title: Text("LOGIN ERROR"), message: Text(errorMessage), dismissButton: .cancel(Text("OK")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

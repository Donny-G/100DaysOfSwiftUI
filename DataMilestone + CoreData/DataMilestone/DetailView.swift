//
//  DetailView.swift
//  DataMilestone
//
//  Created by DeNNiO   G on 04.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var id: String!
    var fetchRequest: FetchRequest<UserCoreData>
    var users: FetchedResults<UserCoreData> { fetchRequest.wrappedValue }
    init(id: String){
       fetchRequest = FetchRequest<UserCoreData>(entity: UserCoreData.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id == %@", id))
   }
    
    
    
    var body: some View {
        Form {
            Section(header: Text("Company")){
          
                Text(users.first!.wrappedCompany)
                    
            }
        
    
                Section(header: Text("About")) {
                    Text("Age: \(users.first!.wrappedAge)")
                    
                    Text(users.first!.wrappedName)
                }
            
                Section(header: Text("Contact data")) {
                    Text("Address: \(users.first!.wrappedAddress)")
                    Text("Email: \(users.first!.wrappedEmail)")
                }
            
    
                Section(header: Text("Friends list")) {
      
                     
                    List(users.first!.friendsArray, id: \.id) { friend in
                       
                        NavigationLink(destination: DetailView(id: friend.wrappedId)){
                        
                   Text(friend.wrappedName)
                        
                                }
                           }
                    
            }
 
           
           
            
            }
            .font(.system(size: 15, weight: Font.Weight.heavy, design: Font.Design.rounded))
        .navigationBarTitle("\(users.first!.wrappedName)", displayMode: .inline)
 

    }
}

/*struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(user: User[0])
    }
}
*/

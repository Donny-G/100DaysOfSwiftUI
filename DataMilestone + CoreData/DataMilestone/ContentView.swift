//
//  ContentView.swift
//  DataMilestone
//
//  Created by DeNNiO   G on 04.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(entity: UserCoreData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserCoreData.name, ascending: true)]) var cdUsers: FetchedResults<UserCoreData>
    
    @Environment(\.managedObjectContext) var moc
    func loadData() {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("invalid url")
            return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let data = data {
                if  let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
                    
                   DispatchQueue.main.async {
                        for user in decodedUsers {
                            let coreUser = UserCoreData(context: self.moc)
                            coreUser.id = user.id
                            coreUser.name = user.name
                            coreUser.about = user.about
                            coreUser.address = user.address
                            coreUser.age = user.age
                            coreUser.company = user.company
                            coreUser.email = user.email
                          
                            if self.cdUsers.isEmpty {
                            for friend in user.friends {
                                
                            let coreFriend = FriendCoreData(context: self.moc)
                                
                            coreFriend.id = friend.id
                             
                            coreFriend.name = friend.name
                                
                            coreUser.addToFriends(coreFriend)
                                }
                                //check for duplicates in FriendsCoreData
                            } else {
                                    for friend in user.friends {
                                        for cdUser in self.cdUsers{
                                            for friendCD in cdUser.friendsArray{
                                        
                                    let coreFriend = FriendCoreData(context: self.moc)
                                                if friendCD.id != friend.id {
                                    coreFriend.id = friend.id
                                    coreFriend.name = friend.name
                                    coreUser.addToFriends(coreFriend)
                                                }
                                            }
                                    }
                            }
                            
                                do {
                                    //check
                                  //  if coreUser.friendsArray.isEmpty{
                                        try self.moc.save()
                                     
                                } catch let error {
                                    print("error \(error.localizedDescription)")
                                }
                            }
                        
                          
                           
                            
                            
                            
                        }
                    
                    }
                    return
                }
            }
             print("Fetch Failed \(error?.localizedDescription  ?? "Unknown Error")")
        }.resume()
        
    }
  
    var body: some View {
        
       NavigationView {
        List {
            ForEach(cdUsers, id: \.id) {
                                        user in
                NavigationLink(destination: DetailView(id: user.wrappedId)) {
                        HStack {
                            Text(user.wrappedName)
                                .font(.system(size: 20, weight: Font.Weight.black, design: Font.Design.rounded))
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                VStack(alignment: .leading){
                                    Text("Age: \(user.wrappedAge)")
                                        .font(.system(size: 10, weight: Font.Weight.black, design: Font.Design.rounded))
                                        .foregroundColor(.secondary)
                                    Text(user.wrappedCompany)
                                        .font(.system(size: 15, weight: Font.Weight.black, design: Font.Design.rounded))
                                        .foregroundColor(.secondary)
                                     Text("\(user.friendsArray.count)")
                                }
                        }
                }
            }
        }
        .navigationBarTitle("UserParser", displayMode: .inline)
        }.onAppear(perform: loadData)
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

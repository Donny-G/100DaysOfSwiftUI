//
//  DetailView.swift
//  Bookworm
//
//  Created by DeNNiO   G on 02.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    var dateString: String {
    let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: book.date ?? Date())
    }
    
    func deleteBook() {
        moc.delete(book)
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    func check() -> String {
        var realImage = ""
        if let image = self.book.genre {
            if !image.isEmpty {
            realImage = image
        } else {
            realImage = "default"
            }}
            return realImage
        }
    
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.check())
                    .resizable()
                    .scaledToFit()
                        .frame(maxWidth: geo.size.width)
                    
                    Text(self.check().uppercased())
                        .font(.caption)
                        .fontWeight(.black)
                    .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(self.book.review ?? "No review")
                .padding()
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                Text(self.dateString)
                    .padding()
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
            
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are uou sure?"), primaryButton: .destructive(Text("Delete"), action: {
                self.deleteBook()
            }), secondaryButton: .cancel())
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "Test review"
        return NavigationView {
            
        
        DetailView(book: book)
        }
    }
}

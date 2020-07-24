//
//  AddBookView.swift
//  Bookworm
//
//  Created by DeNNiO   G on 02.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    //переменная для добавления и записи контекста в CoreData
    @Environment(\.managedObjectContext) var moc
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var date = Date()
    
    //переменная для возвращения на начальное вью, при этом необходимо продублировать ее в изначальном вью для того чтобы работали кнопки NavView
    @Environment(\.presentationMode) var presentationMode
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("\(date)")
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                Section {
                    RatingView(rating: $rating)
                    
                    TextField("Write a review", text: $review)
                }
                Section {
                    Button("Save") {
                        let newBook = Book(context: self.moc)
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review
                        newBook.date = self.date
                        
                        //сохраняем контекст в CoreData
                        try? self.moc.save()
                        //возвращаемся на начальное вью
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }
            }
        .navigationBarTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}

//
//  ContentView.swift
//  WordScramble
//
//  Created by DeNNiO   G on 09.05.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    @State private var scoresDict = [String:Int]()

   func scoresSet()-> [String:Int] {
    var temp = 0
    for word in usedWords{
        temp += word.count
    }
    //add values to dict
    scoresDict[rootWord] = temp
    //save
    UserDefaults.standard.set(scoresDict, forKey: "scoreboard")
    
    print(scoresDict)
    return scoresDict
    }
    
    func addNewWord() {
        let answer = newWord.trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        guard  isPossible(word: answer) else {
            wordError(title: "Word not recognised", message: "You can't just make them up, you know")
            return
        }
        guard  isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }
        usedWords.insert(answer, at: 0)
        scoresSet()
        newWord = ""
    }
    
    func startGame() {
        //load
        let defaults = UserDefaults.standard
        let saved = defaults.object(forKey: "scoreboard") as? [String: Int] ?? [String: Int]()
        scoresDict = saved
        
        usedWords = [String]()
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String)-> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String)-> Bool {
        if word != rootWord {
        var tempword = rootWord
        for letter in word {
            if let pos = tempword.firstIndex(of: letter) {
                tempword.remove(at: pos)
            } else {
                return false
            }
        }
        return true
        } else {
            return false
        }
    }
    
    func isReal(word: String)-> Bool {
        if word.count >= 3{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
        } else {
            return false
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                Form{
                Section(header: Text("Unscrambled words")){
                List(usedWords, id: \.self)
                { word in
                    HStack{
                    Image(systemName: "\(word.count).circle")
                    Text(word)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))
                
                    }}}
                    
                //work with dicts in List
                List {
                    Section(header: Text("Scoreboard")){
                    ForEach(scoresDict.sorted(by: >), id: \.key) { key, value in
                        HStack{
                            Text("\(key)")
                        Image(systemName: "\(value).circle.fill")
                        }
                    }
                    }
                }.listStyle(GroupedListStyle())
            }
        .navigationBarTitle(rootWord)
            .navigationBarItems(trailing: Button(action: startGame) {
                Text("New Game")
            })
        .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

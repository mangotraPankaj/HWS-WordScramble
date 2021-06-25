//
//  ContentView.swift
//  HWS-WordScramble
//
//  Created by Pankaj Mangotra on 22/06/21.
//

import SwiftUI

class FinalScore: ObservableObject {
    @Published var score: Int = 0
    
    func addScore(from word: String) {
        score = score + word.count * 10
    }
}

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @ObservedObject var finalScore = FinalScore()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word",text: $newWord, onCommit:addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                List (usedWords,id:\.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                
                Text("Your score is: \(finalScore.score)")
            }
            .navigationBarTitle(rootWord)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("🔄", action: startGame))
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError, content: {
                Alert(title:Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            })
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Duplicate word", msg: "use original word")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "unrecognised word", msg: "You cant make random words. Try making word from the provided word letters")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", msg: "The word you created is not in the English language. Try Klingon")
            return
        }
        usedWords.insert(answer, at: 0)
        newWord = ""
        finalScore.addScore(from: answer)
    }
    
    func startGame() {
        guard let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            fatalError("Could not load the text file from bundle")
        }
        guard let startWords = try? String(contentsOf: startWordURL)else {return}
        
        let allWords = startWords.components(separatedBy: "\n")
        rootWord = allWords.randomElement() ?? "silkWorm"
        finalScore.score = 0
        usedWords = []
        return
    }
    
    func isOriginal(word: String) -> Bool {
        if(usedWords.contains(word) || (word == rootWord)) { return false }
        else { return true }
    }
    
    func isPossible(word: String) -> Bool {
        
        var tempWord = rootWord
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        
        if(word.utf16.count < 3) {
            return false
        } else {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            
            return misspelledRange.location == NSNotFound
        }
    }
    
    func wordError(title: String, msg: String) {
        errorTitle = title
        errorMessage = msg
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

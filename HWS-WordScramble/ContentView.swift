//
//  ContentView.swift
//  HWS-WordScramble
//
//  Created by Pankaj Mangotra on 22/06/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Section(header: Text("Section 1")) {
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
            }
            Section (header:Text("Section 2")) {
                ForEach(0..<5) {
                    Text("Dynamic row:\($0)")
                }
            }
        }.listStyle(GroupedListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

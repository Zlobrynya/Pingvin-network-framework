//
//  ContentView.swift
//  NetworkTestApp
//
//  Created by Nikita Nikitin on 28.03.2021.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Body
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                 Test().testNetwork()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

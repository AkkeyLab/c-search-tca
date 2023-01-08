//
//  ContentView.swift
//  c-search
//
//  Created by AkkeyLab on 2023/01/08.
//

import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

private struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

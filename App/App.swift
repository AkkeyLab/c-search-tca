//
//  App.swift
//  c-search
//
//  Created by AkkeyLab on 2023/01/08.
//

import Search
import SwiftUI

@main
struct SearchApp: App {
    @State private var searchText: String = ""

    var body: some Scene {
        WindowGroup {
            ContentView(searchText: $searchText)
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    guard let incomingURL = userActivity.webpageURL,
                          let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
                          let queryItems = components.queryItems,
                          let companyName = queryItems.first(where: { $0.name == "name" })?.value
                    else {
                        return
                    }
                    searchText = companyName
                }
        }
    }
}

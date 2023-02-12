//
//  App.swift
//  c-search-clip
//
//  Created by AkkeyLab on 2023/02/12.
//

import Clip
import SwiftUI

@main
struct SearchClipApp: App {
    @State private var companyName: String?

    var body: some Scene {
        WindowGroup {
            Color(uiColor: .systemBackground)
                .overlay {
                    if let companyName {
                        ClipView(companyName: companyName)
                    }
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    guard let incomingURL = userActivity.webpageURL,
                          let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
                          let queryItems = components.queryItems,
                          let nameQueryItem = queryItems.first(where: { $0.name == "name" })
                    else {
                        return
                    }
                    companyName = nameQueryItem.value
                }
        }
    }
}

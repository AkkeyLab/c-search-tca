//
//  App.swift
//  c-search
//
//  Created by AkkeyLab on 2023/01/08.
//

import Company
import Domain
import Search
import SwiftUI

@main
struct SearchApp: App {
    @State private var searchText: String = ""
    @State private var selectedCompany: Company? = nil

    var body: some Scene {
        WindowGroup(id: "search-main") {
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
                .onPreferenceChange(SelectedCompanyPreferenceKey.self) { company in
                    selectedCompany = company
                }
        }
        #if os(visionOS)
        WindowGroup(id: "company-detail") {
            if let selectedCompany {
                CompanyDetailView(company: selectedCompany)
                    .padding(32)
            }
        }
        .defaultSize(width: 0.4, height: 0.2, depth: 1, in: .meters)
        #else
        WindowGroup(id: "company-detail") {
            if let selectedCompany {
                CompanyDetailView(company: selectedCompany)
                    .padding(16)
            }
        }
        #endif
    }
}

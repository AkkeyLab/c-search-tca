//
//  Timeline.swift
//  
//
//  Created by AkkeyLab on 2023/03/18.
//

import WidgetKit

struct CompanyEntry: TimelineEntry {
    let date: Date
    let name: String?
}

struct Provider: TimelineProvider {
    let userDefaults: UserDefaults

    func placeholder(in context: Context) -> CompanyEntry {
        CompanyEntry(date: Date(), name: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (CompanyEntry) -> Void) {
        completion(CompanyEntry(date: Date(), name: String(localized: "AkkeyLab, inc.")))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CompanyEntry>) -> Void) {
        guard let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) else { return }

        let companyName = userDefaults.string(forKey: "company-name-for-widget") ?? String(localized: "Unregistered")
        let entry = CompanyEntry(date: entryDate, name: companyName)

        completion(Timeline(entries: [entry], policy: .atEnd))
    }
}

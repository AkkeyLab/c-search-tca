//
//  Visit.swift
//  Visit
//
//  Created by AkkeyLab on 2023/03/12.
//

import Extension
import Intents
import SwiftUI
import Widget
import WidgetKit

struct Provider: IntentTimelineProvider {
    let userDefaults: UserDefaults

    func placeholder(in context: Context) -> CompanyEntry {
        CompanyEntry(date: Date(), configuration: ConfigurationIntent(), name: "")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CompanyEntry) -> ()) {
        let entry = CompanyEntry(date: Date(), configuration: configuration, name: "Apple, inc.")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CompanyEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let companyName = userDefaults.string(forKey: "company-name-for-widget") ?? "Unregistered"
            let entry = CompanyEntry(date: entryDate, configuration: configuration, name: companyName)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CompanyEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let name: String
}

struct Visit: Widget {
    let kind: String = "Visit"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(userDefaults: .group)) { entry in
            VisitView(entry: entry)
        }
        .configurationDisplayName("Company Name")
        .description("Show your favorite company name")
    }
}

struct VisitPreviews: PreviewProvider {
    static var previews: some View {
        VisitView(entry: CompanyEntry(date: Date(), configuration: ConfigurationIntent(), name: "Apple, inc."))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        VisitView(entry: CompanyEntry(date: Date(), configuration: ConfigurationIntent(), name: "Apple, inc."))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}

extension CompanyEntry: VisitEntryProtocol {}

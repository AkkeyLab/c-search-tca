//
//  VisitView.swift
//  
//
//  Created by AkkeyLab on 2023/03/18.
//

import Extension
import SwiftUI
import WidgetKit

public struct Visit: Widget {
    let kind: String = "Visit"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(userDefaults: .group)) { entry in
            VisitView(entry: entry)
        }
        .configurationDisplayName("Company Name")
        .description("Show your favorite company name")
        .supportedFamilies(families)
    }

    public init() {}

    private var families: [WidgetFamily] {
        #if os(macOS)
        [.systemMedium]
        #else
        [.systemMedium, .accessoryInline]
        #endif
    }
}

public struct VisitView: View {
    let entry: CompanyEntry

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "building.2.crop.circle")
            Text(entry.name ?? String(localized: "Unregistered"))
                .font(.body)
                .redacted(reason: entry.name == nil ? .placeholder : [])
        }
    }
}

public extension VisitView {
    static var mock: Self {
        VisitView(entry: CompanyEntry(date: Date(), name: String(localized: "AkkeyLab, inc.")))
    }
}

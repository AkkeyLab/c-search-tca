//
//  VisitLiveActivity.swift
//  Visit
//
//  Created by AkkeyLab on 2023/03/12.
//

import ActivityKit
import WidgetKit
import SwiftUI

public struct VisitAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public init() {}
    }

    var companyName: String

    public init(companyName: String) {
        self.companyName = companyName
    }
}

@available(iOS 16.2, *)
public struct VisitLiveActivity: Widget {
    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: VisitAttributes.self) { context in
            mainContent(context: context)
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    brandLabel
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Spacer()
                        mainContent(context: context)
                        Spacer()
                    }
                }
            } compactLeading: {
                brandLabel
            } compactTrailing: {
                statusView
            } minimal: {
                statusView
            }
            .widgetURL(URL(string: "http://akkeylab.com"))
            .keylineTint(Color.red)
        }
    }

    private func mainContent(context: ActivityViewContext<VisitAttributes>) -> some View {
        VStack {
            Label(L10n.Activity.pleaseWait, systemImage: "phone.connection")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
            Text(context.attributes.companyName)
                .font(.body)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
        }
    }

    private var brandLabel: some View {
        Label(L10n.Activity.appName, systemImage: "building.2.crop.circle")
    }

    private var statusView: some View {
        Image(systemName: "phone.connection")
            .padding()
    }

    public init() {}
}

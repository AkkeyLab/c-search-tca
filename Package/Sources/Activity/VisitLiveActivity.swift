//
//  VisitLiveActivity.swift
//  Visit
//
//  Created by AkkeyLab on 2023/03/12.
//

#if canImport(ActivityKit)
import ActivityKit
import SwiftUI
import WidgetKit

public struct VisitAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public init() {}
    }

    var companyName: String

    public init(companyName: String) {
        self.companyName = companyName
    }
}

@available(iOS 16.1, *)
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
            let labelString = String(
                localized: "The person in charge will come. Please wait for a little while",
                bundle: .module
            )
            Label(labelString, systemImage: "phone.connection")
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
        Label(
            String(localized: "c-search", bundle: .module),
            systemImage: "building.2.crop.circle"
        )
    }

    private var statusView: some View {
        Image(systemName: "phone.connection")
            .padding()
    }

    public init() {}
}
#endif

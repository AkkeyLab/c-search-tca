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
        // Dynamic stateful properties about your activity go here!
        var value: Int

        public init(value: Int) {
            self.value = value
        }
    }

    // Fixed non-changing properties about your activity go here!
    var name: String

    public init(name: String) {
        self.name = name
    }
}

@available(iOS 16.1, *)
public struct VisitLiveActivity: Widget {
    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: VisitAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }

    public init() {}
}

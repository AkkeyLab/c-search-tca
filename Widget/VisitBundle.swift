//
//  VisitBundle.swift
//  Visit
//
//  Created by AkkeyLab on 2023/03/12.
//

#if canImport(ActivityKit)
import Activity
#endif
import SwiftUI
import Widget
import WidgetKit

@main
struct VisitBundle: WidgetBundle {
    var body: some Widget {
        Visit()
        #if canImport(ActivityKit)
        VisitLiveActivity()
        #endif
    }
}

struct VisitPreviews: PreviewProvider {
    static var previews: some View {
        VisitView.mock
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        #if os(iOS)
        VisitView.mock
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
        #endif
    }
}

#if canImport(ActivityKit)
@available(iOS 16.1, *)
struct VisitLiveActivityPreviews: PreviewProvider {
    static let attributes = VisitAttributes(companyName: "AkkeyLab, inc.")
    static let contentState = VisitAttributes.ContentState()

    @available(iOS 16.1, *)
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
#endif

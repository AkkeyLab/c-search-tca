//
//  VisitBundle.swift
//  Visit
//
//  Created by AkkeyLab on 2023/03/12.
//

import Activity
import Widget
import WidgetKit
import SwiftUI

@main
struct VisitBundle: WidgetBundle {
    var body: some Widget {
        Visit()
        VisitLiveActivity()
    }
}

struct VisitPreviews: PreviewProvider {
    static var previews: some View {
        VisitView.mock
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        VisitView.mock
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
    }
}

@available(iOS 16.2, *)
struct VisitLiveActivityPreviews: PreviewProvider {
    static let attributes = VisitAttributes(name: "Me")
    static let contentState = VisitAttributes.ContentState(value: 3)

    @available(iOS 16.2, *)
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

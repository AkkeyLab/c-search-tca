//
//  VisitBundle.swift
//  Visit
//
//  Created by AkkeyLab on 2023/03/12.
//

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

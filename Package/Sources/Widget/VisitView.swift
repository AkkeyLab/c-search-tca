//
//  VisitView.swift
//  
//
//  Created by AkkeyLab on 2023/03/18.
//

import SwiftUI

public protocol VisitEntryProtocol {
    var date: Date { get }
    var name: String { get }
}

public struct VisitView: View {
    let entry: VisitEntryProtocol

    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "building.2.crop.circle")
            Text(entry.name)
        }
    }

    public init(entry: VisitEntryProtocol) {
        self.entry = entry
    }
}

struct VisitViewPreviews: PreviewProvider {
    static var previews: some View {
        VisitView(entry: VisitEntryMock())
    }
}

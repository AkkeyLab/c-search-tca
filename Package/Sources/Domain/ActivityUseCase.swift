//
//  ActivityUseCase.swift
//  
//
//  Created by AkkeyLab on 2023/03/18.
//

import Activity
import ActivityKit
import Foundation

@available(iOS 16.2, *)
public struct ActivityUseCase {
    public func request(companyName: String) throws -> Activity<VisitAttributes>? {
        let attributes = VisitAttributes(companyName: companyName)
        let contentState = VisitAttributes.ContentState()
        let staleDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let content = ActivityContent(state: contentState, staleDate: staleDate)
        return try Activity<VisitAttributes>.request(attributes: attributes, content: content)
    }

    public func end(activity: Activity<VisitAttributes>) async {
        await activity.end()
    }

    public init() {}
}

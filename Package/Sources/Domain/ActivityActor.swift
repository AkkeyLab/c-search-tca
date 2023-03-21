//
//  ActivityActor.swift
//  
//
//  Created by AkkeyLab on 2023/03/19.
//

#if canImport(ActivityKit)
import Activity
import ActivityKit
import Foundation

@available(iOS 16.1, *)
actor ActivityActor: GlobalActor {
    var activities: [String: Activity<VisitAttributes>?] = [:]

    static let shared = ActivityActor()
    private init() {}

    func request(companyName: String) throws -> Void {
        let attributes = VisitAttributes(companyName: companyName)
        let contentState = VisitAttributes.ContentState()
        let staleDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!

        if #available(iOS 16.2, *) {
            let content = ActivityContent(state: contentState, staleDate: staleDate)
            let activity = try Activity<VisitAttributes>.request(attributes: attributes, content: content)
            activities[companyName] = activity
        } else {
            let activity = try Activity<VisitAttributes>.request(attributes: attributes, contentState: contentState)
            activities[companyName] = activity
        }
    }

    func update(companyName: String) async -> Void {
        guard let activity = activities[companyName] else { return }
        let staleDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!

        if #available(iOS 16.2, *) {
            let contentState = VisitAttributes.ContentState()
            let content = ActivityContent(state: contentState, staleDate: staleDate)
            await activity?.update(content)
        } else {
            let contentState = Activity<VisitAttributes>.ContentState()
            await activity?.update(using: contentState)
        }
    }

    func end(companyName: String) async {
        guard let activity = activities[companyName], let activity else { return }
        await activity.end()
        activities[companyName] = nil
    }
}
#endif

//
//  TestSessionTask.swift
//  
//
//  Created by AkkeyLab on 2023/01/02.
//

import APIKit
import Foundation

final class TestSessionTask {
    var handler: (Data?, URLResponse?, Error?) -> Void
    var cancelled = false

    init(handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.handler = handler
    }
}

extension TestSessionTask: SessionTask {
    func resume() {}

    func cancel() {
        cancelled = true
    }
}

//
//  TestSessionAdapter.swift
//  
//
//  Created by AkkeyLab on 2023/01/02.
//

import APIKit
import Foundation

final class TestSessionAdapter {
    enum Error: Swift.Error {
        case cancelled
    }

    var data = Data()
    var urlResponse =  HTTPURLResponse(
        url: NSURL(string: "")! as URL,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )
    var error: Error?

    private class Runner {
        weak var adapter: TestSessionAdapter?

        @objc func run() {
            adapter?.executeAllTasks()
        }
    }

    private var tasks = [TestSessionTask]()
    private let runner = Runner()
    private let timer: Timer

    init() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.001,
            target: runner,
            selector: #selector(Runner.run),
            userInfo: nil,
            repeats: true
        )

        runner.adapter = self
    }

    func executeAllTasks() {
        defer {
            tasks = []
        }
        tasks.forEach { task in
            task.cancelled
            ? task.handler(nil, nil, Error.cancelled)
            : task.handler(data, urlResponse, error)
        }
    }
}

extension TestSessionAdapter: SessionAdapter {
    func createTask(with URLRequest: URLRequest, handler: @escaping (Data?, URLResponse?, Swift.Error?) -> Void) -> SessionTask {
        let task = TestSessionTask(handler: handler)
        tasks.append(task)

        return task
    }

    func getTasks(with handler: @escaping ([SessionTask]) -> Void) {
        handler(tasks)
    }
}

//
//  Appliable.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

public protocol Appliable {}

public extension Appliable {
    @discardableResult
    func apply(closure: (_ this: Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

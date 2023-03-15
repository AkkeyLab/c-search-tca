//
//  UserDefaultsMock.swift
//  
//
//  Created by AkkeyLab on 2023/03/15.
//

public struct UserDefaultsMock: UserDefaultsProtocol {
    public init() {}
    public func set(_ value: Any?, forKey defaultName: String) {}
    public func string(forKey defaultName: String) -> String? {
        nil
    }
}

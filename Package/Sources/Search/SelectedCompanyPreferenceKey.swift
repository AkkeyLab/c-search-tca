//
//  SelectedCompanyPreferenceKey.swift
//  
//
//  Created by AkkeyLab on 2023/10/04.
//

import Domain
import SwiftUI

public struct SelectedCompanyPreferenceKey: PreferenceKey {
    public typealias Value = Company?

    public static var defaultValue: Value = nil

    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

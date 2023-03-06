//
//  View+Alert.swift
//  
//
//  Created by AkkeyLab on 2023/03/05.
//

import SwiftUI

public extension View {
    func errorAlert<T: LocalizedError>(error: T?, buttonTitle: String, action: @escaping () -> Void) -> some View {
        alert(isPresented: .constant(error != nil), error: error) { _ in
            Button(buttonTitle, action: action)
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

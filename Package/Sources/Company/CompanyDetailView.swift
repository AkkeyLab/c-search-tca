//
//  CompanyDetailView.swift
//
//
//  Created by AkkeyLab on 2023/10/04.
//

import Domain
import SwiftUI

public struct CompanyDetailView: View {
    private let company: Company
    private let onDismiss: (() -> Void)?
    @Environment(\.openWindow) private var openWindow

    public init(company: Company, onDismiss: (() -> Void)? = nil) {
        self.company = company
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                if let onDismiss {
                    Button(
                        action: onDismiss,
                        label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                    )
                } else {
                    Button(
                        action: {
                            openWindow(id: "search-main")
                        },
                        label: {
                            Image(systemName: "magnifyingglass")
                        }
                    )
                }
            }
            InfoView(title: L10n.Company.number, content: company.corporateNumber)
            InfoView(title: L10n.Company.name, content: company.name)
            InfoView(title: L10n.Company.officeAddress, content: company.address)
        }
    }

    private func InfoView(title: String, content: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
            Text(content)
                .font(.headline)
        }
    }
}

private extension Company {
    var address: String {
        prefectureName
        + cityName
        + streetNumber
    }
}

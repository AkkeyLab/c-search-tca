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
    private let showSearchButton: Bool
    @Environment(\.openWindow) private var openWindow

    public init(company: Company, showSearchButton: Bool) {
        self.company = company
        self.showSearchButton = showSearchButton
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showSearchButton {
                HStack {
                    Spacer()
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
            InfoView(
                title: String(localized: "Company Number", bundle: .module),
                content: company.corporateNumber
            )
            InfoView(
                title: String(localized: "Company Name", bundle: .module),
                content: company.name
            )
            InfoView(
                title: String(localized: "Office Address", bundle: .module),
                content: company.address
            )
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

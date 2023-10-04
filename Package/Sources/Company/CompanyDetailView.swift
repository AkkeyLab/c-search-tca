//
//  CompanyDetailView.swift
//
//
//  Created by AkkeyLab on 2023/10/04.
//

import Domain
import SwiftUI

public struct CompanyDetailView: View {
    let company: Company
    let onDismiss: () -> Void

    public init(company: Company, onDismiss: @escaping () -> Void = {}) {
        self.company = company
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                Button(
                    action: onDismiss,
                    label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                )
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

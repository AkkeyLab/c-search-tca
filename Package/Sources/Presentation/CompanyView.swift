//
//  CompanyView.swift
//  
//
//  Created by AkkeyLab on 2023/02/21.
//

import Domain
import SwiftUI

struct CompanyView: View {
    let company: Company

    var body: some View {
        Text(company.name)
    }
}

//struct CompanyViewPreviews: PreviewProvider {
//    static var previews: some View {
//        CompanyView(company: <#Company#>)
//    }
//}

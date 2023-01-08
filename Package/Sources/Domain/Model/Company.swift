//
//  Company.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import Data

public struct Company {
    public let id: Int
    public let corporateNumber: String
    public let name: String
    public let prefectureName: String
    public let cityName: String
    public let streetNumber: String
    public let postCode: String
    public let furigana: String?

    init(id: Int, entity: CompanyEntity) {
        self.id = id
        corporateNumber = entity.corporateNumber
        name = entity.name
        prefectureName = entity.prefectureName
        cityName = entity.cityName
        streetNumber = entity.streetNumber
        postCode = entity.postCode
        furigana = entity.furigana
    }
}

extension Company: Identifiable {}
extension Company: Hashable {}

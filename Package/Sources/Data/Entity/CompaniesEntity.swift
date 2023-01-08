//
//  CompaniesEntity.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import Foundation

// https://www.houjin-bangou.nta.go.jp/documents/k-web-api-kinou-gaiyo.pdf#page=40
public struct CompaniesEntity: Codable {
    public let lastUpdateDate: Date
    public let count: Int
    public let divideNumber: Int
    public let divideSize: Int
    public let corporation: [CompanyEntity]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lastUpdateDate = try container.decodeDate(template: .yyyy_MM_dd, forKey: .lastUpdateDate)
        self.count = try container.decode(Int.self, forKey: .count)
        self.divideNumber = try container.decode(Int.self, forKey: .divideNumber)
        self.divideSize = try container.decode(Int.self, forKey: .divideSize)
        self.corporation = try container.decode([CompanyEntity].self, forKey: .corporation)
    }
}

public struct CompanyEntity: Codable {
    public let sequenceNumber: Int
    public let corporateNumber: String
    public let process: String
    public let correct: String?
    public let updateDate: Date
    public let changeDate: Date
    public let name: String
    public let nameImageId: String?
    public let kind: String
    public let prefectureName: String
    public let cityName: String
    public let streetNumber: String
    public let addressImageId: String?
    public let prefectureCode: String
    public let cityCode: String
    public let postCode: String
    public let addressOutside: String?
    public let addressOutsideImageId: String?
    public let closeDate: Date?
    public let closeCause: String?
    public let successorCorporateNumber: String?
    public let changeCause: String?
    public let assignmentDate: Date
    public let latest: String
    public let enName: String?
    public let enPrefectureName: String?
    public let enCityName: String?
    public let enAddressOutside: String?
    public let furigana: String?
    public let hihyoji: String?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sequenceNumber = try container.decode(Int.self, forKey: .sequenceNumber)
        self.corporateNumber = try container.decode(String.self, forKey: .corporateNumber)
        self.process = try container.decode(String.self, forKey: .process)
        self.correct = try container.decodeStringIfPresent(forKey: .correct)
        self.updateDate = try container.decodeDate(template: .yyyy_MM_dd, forKey: .updateDate)
        self.changeDate = try container.decodeDate(template: .yyyy_MM_dd, forKey: .changeDate)
        self.name = try container.decode(String.self, forKey: .name)
        self.nameImageId = try container.decodeStringIfPresent(forKey: .nameImageId)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.prefectureName = try container.decode(String.self, forKey: .prefectureName)
        self.cityName = try container.decode(String.self, forKey: .cityName)
        self.streetNumber = try container.decode(String.self, forKey: .streetNumber)
        self.addressImageId = try container.decodeStringIfPresent(forKey: .addressImageId)
        self.prefectureCode = try container.decode(String.self, forKey: .prefectureCode)
        self.cityCode = try container.decode(String.self, forKey: .cityCode)
        self.postCode = try container.decode(String.self, forKey: .postCode)
        self.addressOutside = try container.decodeStringIfPresent(forKey: .addressOutside)
        self.addressOutsideImageId = try container.decodeStringIfPresent(forKey: .addressOutsideImageId)
        self.closeDate = try container.decodeDateIfPresent(template: .yyyy_MM_dd, forKey: .closeDate)
        self.closeCause = try container.decodeStringIfPresent(forKey: .closeCause)
        self.successorCorporateNumber = try container.decodeStringIfPresent(forKey: .successorCorporateNumber)
        self.changeCause = try container.decodeStringIfPresent(forKey: .changeCause)
        self.assignmentDate = try container.decodeDate(template: .yyyy_MM_dd, forKey: .assignmentDate)
        self.latest = try container.decode(String.self, forKey: .latest)
        self.enName = try container.decodeStringIfPresent(forKey: .enName)
        self.enPrefectureName = try container.decodeStringIfPresent(forKey: .enPrefectureName)
        self.enCityName = try container.decodeStringIfPresent(forKey: .enCityName)
        self.enAddressOutside = try container.decodeStringIfPresent(forKey: .enAddressOutside)
        self.furigana = try container.decodeStringIfPresent(forKey: .furigana)
        self.hihyoji = try container.decodeStringIfPresent(forKey: .hihyoji)
    }
}

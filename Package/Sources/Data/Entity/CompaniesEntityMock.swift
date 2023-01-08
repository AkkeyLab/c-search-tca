//
//  CompaniesEntityMock.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import Foundation

public extension CompaniesEntity {
    static var mockData: Data? {
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><corporations><lastUpdateDate>2022-12-28</lastUpdateDate><count>1</count><divideNumber>1</divideNumber><divideSize>1</divideSize><corporation><sequenceNumber>1</sequenceNumber><corporateNumber>8011001150296</corporateNumber><process>01</process><correct>0</correct><updateDate>2022-10-14</updateDate><changeDate>2022-10-14</changeDate><name>ＡｋｋｅｙＬａｂ株式会社</name><nameImageId/><kind>301</kind><prefectureName>東京都</prefectureName><cityName>渋谷区</cityName><streetNumber>道玄坂１丁目１６－６二葉ビル８Ｂ</streetNumber><addressImageId/><prefectureCode>13</prefectureCode><cityCode>113</cityCode><postCode>1500043</postCode><addressOutside/><addressOutsideImageId/><closeDate/><closeCause/><successorCorporateNumber/><changeCause/><assignmentDate>2022-10-14</assignmentDate><latest>1</latest><enName/><enPrefectureName/><enCityName/><enAddressOutside/><furigana>アッキーラボ</furigana><hihyoji>0</hihyoji></corporation></corporations>"
            .data(using: .utf8)
    }
}

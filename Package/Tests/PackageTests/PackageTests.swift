import APIKit
import ComposableArchitecture
import MapKit
import XCTest
@testable import Data
@testable import Domain

final class PackageTests: XCTestCase {
    var adapter: TestSessionAdapter!
    var session: Session!

    override func setUp() {
        super.setUp()
        adapter = TestSessionAdapter()
        session = Session(adapter: adapter)
    }

    // Test the following ranges
    // Action -------------> Reducer --> State
    // Action <-- Effect <-- Reducer
    @MainActor
    func testSuccessSearchCompaniesReducer() async {
        let store = TestStore(
            initialState: SearchCompaniesReducer.State(),
            reducer: SearchCompaniesReducer()
                .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase(gateway: SearchCompaniesGatewayMock()))
        )

        await store.send(.search(companyName: ""))

        let company = Company(
            id: .zero,
            corporateNumber: "8011001150296",
            name: "ＡｋｋｅｙＬａｂ株式会社",
            prefectureName: "東京都",
            cityName: "渋谷区",
            streetNumber: "道玄坂１丁目１６－６二葉ビル８Ｂ",
            postCode: "1500043",
            furigana: "アッキーラボ"
        )

        await store.receive(.searchResponse(.success([company]))) {
            $0.companies = [company]
        }
    }

    // Test the following ranges
    // Action -------------> Reducer --> State
    // Action <-- Effect <-- Reducer
    @MainActor
    func testFailureSearchCompaniesReducer() async {
        struct FailureGatewayMock: SearchCompaniesGatewayProtocol {
            func search(name: String) async throws -> CompaniesEntity {
                throw TestError.test
            }
        }

        let store = TestStore(
            initialState: SearchCompaniesReducer.State(),
            reducer: SearchCompaniesReducer()
                .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase(gateway: FailureGatewayMock()))
        )

        await store.send(.search(companyName: ""))

        await store.receive(.searchResponse(.failure(TestError.test))) {
            $0.companies = []
            $0.error = LocalizedAlertError(error: TestError.test)
        }

        await store.send(.confirmedError) {
            $0.companies = []
            $0.error = nil
        }
    }

    // Test the following ranges
    // Action -------------> Reducer --> State
    // Action <-- Effect <-- Reducer
    @MainActor
    func testSuccessCompanyReducer() async {
        struct CLGeocoderMock: CLGeocoderProtocol {
            func geocodeAddressString(_ addressString: String, in region: CLRegion?, preferredLocale locale: Locale?) async throws -> [CLLocation] {
                XCTFail()
                return []
            }
        }

        struct CompanyAddressRepositoryMock: CompanyAddressRepositoryProtocol {
            func load<T: CompanyAddressEntity>() throws -> [T] {
                [
                    CompanyAddressEntityMock() as! T
                ]
            }

            func append(address: String, latitude: Double, longitude: Double) throws {
                XCTFail()
            }

            func saveIfNeeded() throws {
                XCTFail()
            }
        }

        let useCase = GeocodeUseCase(geocoder: CLGeocoderMock(), repository: CompanyAddressRepositoryMock())
        let store = TestStore(
            initialState: CompanyReducer.State(company: .mock),
            reducer: CompanyReducer(userDefaults: UserDefaultsMock())
                .dependency(\.geocodeUseCase, useCase)
        )

        await store.send(.geocode)

        let coordinate = CLLocationCoordinate2D(
            latitude: 35.652832,
            longitude: 139.839478
        )

        await store.receive(.geocodeResponse(.success([coordinate]))) {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            $0.regions = [
                MKCoordinateRegion(center: coordinate, span: span)
            ]
        }
    }

    // Test the following ranges
    // Action -------------> Reducer --> State
    // Action <-- Effect <-- Reducer
    @MainActor
    func testFailureCompanyReducer() async {
        struct CLGeocoderMock: CLGeocoderProtocol {
            func geocodeAddressString(_ addressString: String, in region: CLRegion?, preferredLocale locale: Locale?) async throws -> [CLLocation] {
                throw TestError.test
            }
        }

        struct CompanyAddressRepositoryMock: CompanyAddressRepositoryProtocol {
            func load<T: CompanyAddressEntity>() throws -> [T] {
                []
            }

            func append(address: String, latitude: Double, longitude: Double) throws {
                XCTFail()
            }

            func saveIfNeeded() throws {
                XCTFail()
            }
        }

        let useCase = GeocodeUseCase(geocoder: CLGeocoderMock(), repository: CompanyAddressRepositoryMock())
        let store = TestStore(
            initialState: CompanyReducer.State(company: .mock),
            reducer: CompanyReducer(userDefaults: UserDefaultsMock())
                .dependency(\.geocodeUseCase, useCase)
        )

        await store.send(.geocode)

        await store.receive(.geocodeResponse(.failure(TestError.test))) {
            $0.regions = []
            $0.error = LocalizedAlertError(error: TestError.test)
        }

        await store.send(.confirmedError) {
            $0.regions = []
            $0.error = nil
        }
    }

    // Test the following ranges
    // Gateway --> UseCase
    func testConvertedEntityToModel() async throws {
        let gateway = SearchCompaniesGatewayMock()
        let useCase = SearchCompaniesUseCase(gateway: gateway)

        let corporationsEntity = try await gateway.search(name: "")
        let corporationEntity = try XCTUnwrap(corporationsEntity.corporation.first)

        let result = try await useCase.search(name: "")
        let corporation = try XCTUnwrap(result.first)

        XCTAssertEqual(corporation.id, .zero)
        XCTAssertEqual(corporationEntity.corporateNumber, corporation.corporateNumber)
        XCTAssertEqual(corporationEntity.name, corporation.name)
        XCTAssertEqual(corporationEntity.prefectureName, corporation.prefectureName)
        XCTAssertEqual(corporationEntity.cityName, corporation.cityName)
        XCTAssertEqual(corporationEntity.streetNumber, corporation.streetNumber)
        XCTAssertEqual(corporationEntity.postCode, corporation.postCode)
        XCTAssertEqual(corporationEntity.furigana, corporation.furigana)
    }

    // Test the following ranges
    // ApiRequest --> Gateway
    func testRecentlyEstablishedCompany() async throws {
        adapter.data = try XCTUnwrap(CompaniesEntity.mockData)

        let request = CompaniesRequest(
            apiKey: "",
            name: "",
            type: .unicodeXML,
            mode: .partialMatch,
            kind: .normal,
            hasClosed: false
        )
        let result = try await session.response(for: request)
        XCTAssertEqual(result.lastUpdateDate.description, "2022-12-27 15:00:00 +0000")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.divideNumber, 1)
        XCTAssertEqual(result.divideSize, 1)
        let corporation = try XCTUnwrap(result.corporation.first)
        XCTAssertEqual(corporation.sequenceNumber, 1)
        XCTAssertEqual(corporation.corporateNumber, "8011001150296")
        XCTAssertEqual(corporation.process, "01")
        XCTAssertEqual(corporation.correct, "0")
        XCTAssertEqual(corporation.updateDate.description, "2022-10-13 15:00:00 +0000")
        XCTAssertEqual(corporation.changeDate.description, "2022-10-13 15:00:00 +0000")
        XCTAssertEqual(corporation.name, "ＡｋｋｅｙＬａｂ株式会社")
        XCTAssertNil(corporation.nameImageId)
        XCTAssertEqual(corporation.kind, "301")
        XCTAssertEqual(corporation.prefectureName, "東京都")
        XCTAssertEqual(corporation.cityName, "渋谷区")
        XCTAssertEqual(corporation.streetNumber, "道玄坂１丁目１６－６二葉ビル８Ｂ")
        XCTAssertNil(corporation.addressImageId)
        XCTAssertEqual(corporation.prefectureCode, "13")
        XCTAssertEqual(corporation.cityCode, "113")
        XCTAssertEqual(corporation.postCode, "1500043")
        XCTAssertNil(corporation.addressOutside)
        XCTAssertNil(corporation.addressOutsideImageId)
        XCTAssertNil(corporation.closeDate)
        XCTAssertNil(corporation.closeCause)
        XCTAssertNil(corporation.successorCorporateNumber)
        XCTAssertNil(corporation.changeCause)
        XCTAssertEqual(corporation.assignmentDate.description, "2022-10-13 15:00:00 +0000")
        XCTAssertEqual(corporation.latest, "1")
        XCTAssertNil(corporation.enName)
        XCTAssertNil(corporation.enPrefectureName)
        XCTAssertNil(corporation.enCityName)
        XCTAssertNil(corporation.enAddressOutside)
        XCTAssertEqual(corporation.furigana, "アッキーラボ")
        XCTAssertEqual(corporation.hihyoji, "0")
    }

    static var addressMock: String {
        let company = Company.mock
        return company.prefectureName
        + company.cityName
        + company.streetNumber
    }

    func testCaching() async throws {
        struct CLGeocoderMock: CLGeocoderProtocol {
            func geocodeAddressString(_ addressString: String, in region: CLRegion?, preferredLocale locale: Locale?) async throws -> [CLLocation] {
                [
                    CLLocation(latitude: 35.652832, longitude: 139.839478)
                ]
            }
        }

        struct CompanyAddressRepositoryMock: CompanyAddressRepositoryProtocol {
            func load<T: CompanyAddressEntity>() throws -> [T] {
                []
            }

            func append(address: String, latitude: Double, longitude: Double) throws {
                XCTAssertEqual(address, PackageTests.addressMock)
            }

            func saveIfNeeded() throws {
                XCTAssert(true)
            }
        }

        let useCase = GeocodeUseCase(geocoder: CLGeocoderMock(), repository: CompanyAddressRepositoryMock())
        let coordinate = try await useCase.geocodeCompanyAddress(Company.mock)
        XCTAssertEqual(coordinate.count, 1)
        XCTAssertEqual(coordinate.first?.latitude, 35.652832)
        XCTAssertEqual(coordinate.first?.longitude, 139.839478)
    }

    func testCacheLoad() async throws {
        struct CLGeocoderMock: CLGeocoderProtocol {
            func geocodeAddressString(_ addressString: String, in region: CLRegion?, preferredLocale locale: Locale?) async throws -> [CLLocation] {
                XCTFail()
                return []
            }
        }

        struct CompanyAddressRepositoryMock: CompanyAddressRepositoryProtocol {
            func load<T: CompanyAddressEntity>() throws -> [T] {
                [
                    CompanyAddressEntityMock() as! T
                ]
            }

            func append(address: String, latitude: Double, longitude: Double) throws {
                XCTFail()
            }

            func saveIfNeeded() throws {
                XCTFail()
            }
        }

        let useCase = GeocodeUseCase(geocoder: CLGeocoderMock(), repository: CompanyAddressRepositoryMock())
        let coordinate = try await useCase.geocodeCompanyAddress(Company.mock)
        XCTAssertEqual(coordinate.count, 1)
        XCTAssertEqual(coordinate.first?.latitude, 35.652832)
        XCTAssertEqual(coordinate.first?.longitude, 139.839478)
    }
}

private final class CompanyAddressEntityMock: CompanyAddressEntity {
    override var address: String? {
        set {}
        get { PackageTests.addressMock }
    }

    override var latitude: Double {
        set {}
        get { 35.652832 }
    }

    override var longitude: Double {
        set {}
        get { 139.839478 }
    }
}

private enum TestError: String, Error, LocalizedError {
    case test

    var errorDescription: String? {
        rawValue
    }
}

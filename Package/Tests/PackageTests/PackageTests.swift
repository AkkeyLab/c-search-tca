import ComposableArchitecture
import XCTest
@testable import Data
@testable import Domain

final class PackageTests: XCTestCase {
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

    @MainActor
    func testFailureSearchCompaniesReducer() async {
        enum TestError: String, Error, LocalizedError {
            case test

            var errorDescription: String? {
                rawValue
            }
        }

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
}

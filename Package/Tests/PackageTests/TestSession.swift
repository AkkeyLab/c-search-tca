import Foundation
@testable import Data

final class TestSession: Session {
    var data: Data?

    func data(for request: URLRequest) async throws -> Data {
        data!
    }
}

import XCTest

class DatesTests: XCTestCase {

    func testNewPromoCodeNotExpired() {
        let promoCode = PromoCode(createdAt: Date())
        XCTAssertFalse(promoCode.isExpired())
    }

    func testOldPromoCodeExpired() {
        let promoCode = PromoCode(createdAt: Date().addingTimeInterval(-(15 * 24 * 60 * 60)))
        XCTAssertTrue(promoCode.isExpired())
    }
}

struct PromoCode {

    let createdAt: Date

    func isExpired() -> Bool {
        return Date().timeIntervalSince(createdAt) > TimeInterval(14 * 24 * 60 * 60)
    }
}

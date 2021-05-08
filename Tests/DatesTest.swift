import XCTest

class DatesTests: XCTestCase {

    func testNewPromoCodeNotExpired_bad() {
        let promoCode = PromoCode(createdAt: Date())
        XCTAssertFalse(promoCode.isExpired_bad())
    }

    func testOldPromoCodeExpired_bad() {
        let promoCode = PromoCode(createdAt: Date().addingTimeInterval(-(15 * 24 * 60 * 60)))
        XCTAssertTrue(promoCode.isExpired_bad())
    }

    // Notice that making the validity interval explicit allows for better test names, too.
    // The lesson here is more that this approach is clearer rather than its tests names are
    // "better", but I guess that's the point no? If you can write a clear test, then the code is
    // clear too...
    func testPromoCodeCreatedWithinValidityIsNotExpired() {
        let validityInterval: TimeInterval = 60
        let createdDate = Date()
        let promoCode = PromoCode(createdAt: createdDate, validityInterval: validityInterval)
        XCTAssertFalse(promoCode.isExpired(at: Date(timeInterval: 59, since: createdDate)))
    }

    func testPromoCodeCreatedAtValidityIsNotExpired() {
        let validityInterval: TimeInterval = 60
        let createdDate = Date()
        let promoCode = PromoCode(createdAt: createdDate, validityInterval: validityInterval)
        XCTAssertFalse(promoCode.isExpired(at: Date(timeInterval: 60, since: createdDate)))
    }

    func testPromoCodeCreatedBeforeValidityIsExpired() {
        let validityInterval: TimeInterval = 60
        let createdDate = Date()
        let promoCode = PromoCode(createdAt: createdDate, validityInterval: validityInterval)
        XCTAssertTrue(promoCode.isExpired(at: Date(timeInterval: 61, since: createdDate)))
    }
}

struct PromoCode {

    let createdAt: Date
    private(set) var validityInterval: TimeInterval = 14 * 24 * 60 * 60

    func isExpired_bad() -> Bool {
        return Date().timeIntervalSince(createdAt) > TimeInterval(14 * 24 * 60 * 60)
    }

    func isExpired(at date: Date = Date()) -> Bool {
        return date.timeIntervalSince(createdAt) > validityInterval
    }
}

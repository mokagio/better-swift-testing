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

    // MARK: - Different example

    func testExpiredProduct() {
        let product = Product(expirationYear: 2000, month: 1, day: 1)
        XCTAssertTrue(product.expired)
    }

    // This is just an example of bad use of dates.
    //
    // The test passed when I wrote it, but will fail if run after the date.
    //
    // You could compensate by using a date in the very distant future, but the code is
    // nevertheless flawed: you have no control over how long the code will be running for, there is
    // always a bit of possibility that the time will come to pass and the test start failing.
    func testValidProduct() throws {
        try XCTSkipIf(true, "Skipping test. This is just an example of a test that will fail.")

        let product = Product(expirationYear: 2021, month: 5, day: 12)
        XCTAssertFalse(product.expired)
    }

    func testExpiredProduct_good() {
        let product = Product(expirationYear: 2021, month: 1, day: 1)
        XCTAssertTrue(product.isExpired(at: Date.with(year: 2021, month: 1, day: 2)))
        XCTAssertTrue(product.isExpired(at: .distantFuture))
    }

    func testValidProduct_good() {
        let product = Product(expirationYear: 2021, month: 1, day: 1)
        XCTAssertFalse(product.isExpired(at: Date.with(year: 2020, month: 12, day: 31)))
        XCTAssertFalse(product.isExpired(at: .distantPast))
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

struct Product {

    let expiryDate: Date

    var expired: Bool { expiryDate.timeIntervalSinceNow < 0 }

    init(expirationYear year: Int, month: Int, day: Int) {
        self.expiryDate = DateComponents(calendar: .current, year: year, month: month, day: day).date! }

    func isExpired(at date: Date = Date()) -> Bool {
        expiryDate.timeIntervalSince(date) < 0
    }
}


extension Date {

    static func with(calendar: Calendar = .current, year: Int, month: Int, day: Int) -> Date {
        DateComponents(calendar: calendar, year: year, month: month, day: day).date!
    }
}

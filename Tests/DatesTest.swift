import XCTest

class DatesDecoupleFromSystemClockExamples: XCTestCase {

    struct PromoCode {
        let createdAt: Date
        // TODO: a further improvement in test quality would be to make this injectable, too.
        // That way, the tests could focus on the comparison behavior without being constrained by
        // the value of expiration interval. If the interval changes in production, the tests will
        // still pass.
        private let expiry: TimeInterval = 365 * 24 * 60 * 60

        func isExpired(at referenceDate: Date = Date()) -> Bool {
            return referenceDate.timeIntervalSince(createdAt) > expiry
        }
    }

    func testIsExpiredFalseBeforeOneYear_bad() {
        let promoCode = PromoCode(createdAt: Date.with(year: 2020, month: 6, day: 4))
        XCTAssertFalse(promoCode.isExpired())
    }

    func testIsExpiredFalseAfterOneYear_bad() {
        let promoCode = PromoCode(createdAt: Date.with(year: 2020, month: 1, day: 4))
        XCTAssertTrue(promoCode.isExpired())
    }

    func testIsExpiredFalseBeforeOneYear_good() {
        let promoCode = PromoCode(createdAt: Date.with(year: 2020, month: 6, day: 4))
        XCTAssertFalse(promoCode.isExpired(at: Date.with(year: 2021, month: 6, day: 3)))
    }

    func testIsExpiredFalseAfterOneYear_good() {
        let promoCode = PromoCode(createdAt: Date.with(year: 2020, month: 1, day: 4))
        XCTAssertTrue(promoCode.isExpired(at: Date.with(year: 2021, month: 1, day: 4)))
    }
}

extension Date {

    private static var formatter = DateFormatter.withFormat("YYYY-MM-DD")

    static func with(calendar: Calendar = .current, year: Int, month: Int, day: Int) -> Date {
        // Because the `calendar` value is non-nil, it's safe to force unwrap the `date` value
        DateComponents(calendar: calendar, year: year, month: month, day: day).date!
    }

    init?(_ string: String) {
        guard let date = Date.formatter.date(from: string) else { return nil }
        self = date
    }
}

extension DateFormatter {

    static func withFormat(_ format: String) -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = format
        return df
    }
}

extension TimeInterval {

    static let week: TimeInterval = 7 * 24 * 60 * 60
    static let oneWeek: TimeInterval = week
}

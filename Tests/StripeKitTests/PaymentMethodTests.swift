import XCTest
@testable import StripeKit

final class PaymentMethodTests: XCTestCase {
    func testSubscriptionDecodesExpandedAmazonPayPaymentMethod() throws {
        let json = """
        {
            "id": "sub_test",
            "object": "subscription",
            "created": 1700000000,
            "automatic_tax": {"enabled": false},
            "status": "active",
            "default_payment_method": {
                "id": "pm_test",
                "object": "payment_method",
                "created": 1700000000,
                "type": "amazon_pay",
                "amazon_pay": {}
            },
            "payment_settings": {"payment_method_types": ["amazon_pay"]}
        }
        """
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970

        let subscription = try decoder.decode(Subscription.self, from: Data(json.utf8))
        let method = try XCTUnwrap(subscription.$defaultPaymentMethod)
        XCTAssertEqual(subscription.status, .active)
        XCTAssertEqual(method.id, "pm_test")
        XCTAssertEqual(method.type, .amazonPay)
        XCTAssertNil(method.card)
        XCTAssertEqual(subscription.paymentSettings?.paymentMethodTypes, [.amazonPay])
        XCTAssertEqual(String(data: try JSONEncoder().encode(method.type), encoding: .utf8), "\"amazon_pay\"")
    }
}

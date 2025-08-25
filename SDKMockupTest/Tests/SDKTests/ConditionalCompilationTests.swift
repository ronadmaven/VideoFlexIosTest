//
//  ConditionalCompilationTests.swift
//  
//
//  Created by Test on 23/01/2025.
//

import XCTest
@testable import SDK

final class ConditionalCompilationTests: XCTestCase {
    
    func testSDKInstantiation() throws {
        let config = SDKConfig(baseURL: URL(string: "https://example.com")!)
        let sdk = TheSDK(config: config)
        
        print("SDK Implementation Type: \(sdk.implementationType)")
        
        XCTAssertNotNil(sdk)
        XCTAssertFalse(sdk.isSubscribed)
        XCTAssertNotNil(sdk.userId)
    }
    
    func testSubscriptionUpdate() async throws {
        let config = SDKConfig(baseURL: URL(string: "https://example.com")!)
        let sdk = TheSDK(config: config)
        
        // Test the action method
        let event = JSEventWrapper(
            id: UUID().uuidString,
            name: "purchase",
            parameters: ["product": "subscription"]
        )
        
        let result = try await sdk.action(event: event)
        
        XCTAssertNotNil(result)
        XCTAssertTrue(sdk.isSubscribed)
        
        if let result = result {
            XCTAssertEqual(result["success"] as? Bool, true)
            XCTAssertEqual(result["subscribed"] as? Bool, true)
        }
    }
    
    func testCompilerDirectives() {
        #if swift(>=5.9) && canImport(Observation) && (os(iOS) || os(tvOS) || os(watchOS) || os(visionOS))
        print("Using @Observable implementation for iOS 17+")
        #else
        print("Using ObservableObject implementation")
        #endif
        
        // This test always passes, it's just to verify compilation
        XCTAssertTrue(true)
    }
}

//
//  APITests.swift
//  kidsnoteTests
//
//  Created by Steven Jiang on 2022/12/30.
//

import XCTest
@testable import kidsnote

final class APITests: XCTestCase {

    
    let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=law")
    
    func testAPISuccess() {
        let exp = XCTestExpectation(description: "API Request Succeed")
        
        Task {
            do {
                let result = try await API().request(type: VolumeSearchResult.self, url: url!)
                XCTAssertNotNil(result)
                exp.fulfill()
            }
            catch {
                print(error)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
}

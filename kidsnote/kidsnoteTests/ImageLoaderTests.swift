//
//  ImageLoaderTests.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import XCTest
@testable import kidsnote

final class ImageLoaderTests: XCTestCase {

    let url = URL(string: "http://books.google.com/books/content?id=SmYvDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api")
    func testLoadImageSucceed() {
        let imageLoader = ImageLoader()
        let exp = XCTestExpectation(description: "Load Image Succeed")
        Task {
            do {
                let image = try await imageLoader.fetch(url!)
                XCTAssertNotNil(image)
                exp.fulfill()
            }
            catch {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }
}

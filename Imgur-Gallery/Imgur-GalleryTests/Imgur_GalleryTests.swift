//
//  Imgur_GalleryTests.swift
//  Imgur-GalleryTests
//
//  Created by Saifali Terdale on 14/06/23.
//

import XCTest
@testable import Imgur_Gallery

final class Imgur_GalleryTests: XCTestCase {

    override class func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testValidDate() {
        // Arrange
        let date = 1686660218.0
        let expectedDateString = "Jun 13, 2023 at 6:13:38 PM"

        // ACT

        // Assert
        XCTAssertEqual(expectedDateString, date.getDate())
    }
}

//
//  ImageServiceTests.swift
//  Imgur-GalleryTests
//
//  Created by Saifali Terdale on 15/06/23.
//

import XCTest
@testable import Imgur_Gallery

final class ImageServiceTests: XCTestCase {

    let dataFetchedExpectation = XCTestExpectation(description: "Callback for valid data")
    let dataFetchingFailExpectation = XCTestExpectation(description: "callback for error/empty data")
    let longTimeout = TimeInterval(10)

    override class func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testImageService_withData() {
        // Arrange
        let imageSerview = ImageService(delegate: self)

        // Act
        imageSerview.getTopImagesOfWeek(text: "a")

        // Assert
        let results = XCTWaiter().wait(for: [dataFetchedExpectation], timeout: longTimeout)
        XCTAssertEqual(results, .completed, "Directory was not created correctly")
    }

    func testImageService_withInvalidData() {
        // Arrange
        let imageSerview = ImageService(delegate: self)

        // Act
        imageSerview.getTopImagesOfWeek(text: "Vvvvvvvvvvvvvvvvvvvvvvvvvv777777")

        // Assert
        let results = XCTWaiter().wait(for: [dataFetchingFailExpectation], timeout: longTimeout)
        XCTAssertEqual(results, .completed, "Directory was not created correctly")
    }
}

extension ImageServiceTests: ImageServiceDelegate {
    func getTopImagesOfWeek(data: [ImageData]?) {
        dataFetchedExpectation.fulfill()
    }

    func didFailToFetchResult() {
        dataFetchingFailExpectation.fulfill()
    }
}

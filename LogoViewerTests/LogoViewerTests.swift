//
//  LogoViewerTests.swift
//  LogoViewerTests
//
//  Created by XenoX on 03/04/2019.
//  Copyright © 2019 OpenClassrooms. All rights reserved.
//

import XCTest
@testable import LogoViewer

class LogoViewerTests: XCTestCase {
    func testGetPictureShouldFailedCallbackIfError() {
        let logoService = LogoService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        let expectation = XCTestExpectation(description: "Waiting for queue change.")

        logoService.getLogo(domain: "https://openclassrooms.com") { (success, logo) in
            XCTAssertFalse(success)
            XCTAssertNil(logo)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPictureShouldFailedCallbackIfNoData() {
        let logoService = LogoService(session: URLSessionFake(data: nil, response: nil, error: nil))

        let expectation = XCTestExpectation(description: "Waiting for queue change.")

        logoService.getLogo(domain: "https://openclassrooms.com") { (success, logo) in
            XCTAssertFalse(success)
            XCTAssertNil(logo)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPictureShouldFailedCallbackIfIncorrectData() {
        let logoService = LogoService(session: URLSessionFake(
            data: FakeResponseData.logoIncorrectData,
            response: nil,
            error: nil))

        let expectation = XCTestExpectation(description: "Waiting for queue change.")

        logoService.getLogo(domain: "https://openclassrooms.com") { (success, logo) in
            XCTAssertFalse(success)
            XCTAssertNil(logo)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPictureShouldFailedCallbackIfIncorrectResponse() {
        let logoService = LogoService(session: URLSessionFake(
            data: FakeResponseData.logoCorrectData,
            response: FakeResponseData.responseKO,
            error: nil))

        let expectation = XCTestExpectation(description: "Waiting for queue change.")

        logoService.getLogo(domain: "https://openclassrooms.com") { (success, logo) in
            XCTAssertFalse(success)
            XCTAssertNil(logo)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetPictureShouldSuccessCallbackIfCorrectResponseAndData() {
        let logoService = LogoService(session: URLSessionFake(
            data: FakeResponseData.logoCorrectData,
            response: FakeResponseData.responseOK,
            error: nil))

        let expectation = XCTestExpectation(description: "Waiting for queue change.")

        logoService.getLogo(domain: "https://openclassrooms.com") { (success, logo) in
            let logoImage = (try?
                Data(contentsOf: Bundle(for: LogoViewerTests.self).url(forResource: "response", withExtension: "png")!))
                ?? Data()

            XCTAssertTrue(success)
            XCTAssertNotNil(logo)
            XCTAssertEqual(logoImage, logo!.imageData)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}

//
//  PersistenceControllerTests.swift
//  GitHubClientTests
//
//  Created by fox on 30/04/2024.
//

import XCTest
@testable import GitHubClient

final class PersistenceControllerTests: XCTestCase {

    func testPersistenceController() throws {
        let memory = PersistenceController.memory
        XCTAssertNotNil(memory)
        let memoryDecoder = PersistenceController.memory.jsonDecoder
        XCTAssertNotNil(memoryDecoder)
        let dbDecoder = PersistenceController.db.jsonDecoder
        XCTAssertNotNil(dbDecoder)
    }
}

//
//  GitHubClientTests.swift
//  GitHubClientTests
//
//  Created by fox on 20/04/2024.
//

import XCTest
@testable import GitHubClient

final class GitHubClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testRepositoryEntity() throws {
        var managedObjectContext = PersistenceController.test
        
        guard let jsonData = "Repository".data else {
            throw GitHubError.invalidDecode
        }
                        
        let repository = try managedObjectContext.jsonDecoder.decode(Repository.self, from: jsonData)
        XCTAssertNotNil(repository)
                        
        XCTAssertEqual(repository.brief, "The Go programming language")
        XCTAssertEqual(repository.fullName, "golang/go")
        XCTAssertEqual(repository.icon, "https://avatars.githubusercontent.com/u/4314092?v=4")
        XCTAssertEqual(repository.language, "Go")
        XCTAssertEqual(repository.name, "go")
        XCTAssertEqual(repository.stars, 119480)
    }
}

//
//  GitHubClientTests.swift
//  GitHubClientTests
//
//  Created by fox on 20/04/2024.
//

import CoreData
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
        var persistence = PersistenceController.cache
        
        guard let jsonData = "Repository".data else {
            throw GitHubError.invalidDecode
        }
                        
        let repository = try persistence.jsonDecoder.decode(Repository.self, from: jsonData)
        test(repository: repository)
    }
    
    func testRepositoryResponse() throws {
        var persistence = PersistenceController.cache
        
        guard let jsonData = "GitHubRepositoryResponse".data else {
            throw GitHubError.invalidDecode
        }

        // Testing parsing of repository response
        let response = try persistence.jsonDecoder.decode(RepositoryResponse.self, from: jsonData)
        XCTAssertNotNil(response)
        
        let items = response.repositories
        XCTAssertNotNil(items)
        XCTAssertEqual(items?.count, 30)
        
        // Fetch the repositories from the Core Data
        let fetchRequest = RepositoryResponse.fetchRequest()
        XCTAssertNotNil(fetchRequest)
        
        // Check if we have only one response
        let objects = try persistence.container.viewContext.fetch(fetchRequest)
        XCTAssertEqual(objects.count, 1)

        // Now check the repositories
        let repositories = objects.first?.repositories
        XCTAssertEqual(repositories?.count, items?.count)

        // Fetch the Go language repository
        let repositoryFetchRequest = Repository.fetchRequest()
        XCTAssertNotNil(repositoryFetchRequest)

        repositoryFetchRequest.predicate = NSPredicate(
            format: "name LIKE %@", "go"
        )
        
        // if this is Go repository?
        let repository = try persistence.container.viewContext.fetch(repositoryFetchRequest).first
        
        // Should probe this
        test(repository: repository)
    }
    
    func testCache() throws {
        let cacheUrl = try Data.cacheUrl()
        XCTAssertNotNil(cacheUrl)
        XCTAssertTrue(cacheUrl.absoluteString.contains("Repository.json"))
        
        guard let jsonData = "GitHubRepositoryResponse".data else {
            throw GitHubError.invalidDecode
        }

        try jsonData.saveCache()
        let data = try Data.retrieveCache()
        XCTAssertNotNil(data)
        XCTAssertEqual(data, jsonData)
    }
}

extension GitHubClientTests {

    private func test(repository: Repository?) {
        XCTAssertNotNil(repository)
        XCTAssertEqual(repository?.brief, "The Go programming language")
        XCTAssertEqual(repository?.fullName, "golang/go")
        XCTAssertEqual(repository?.icon, "https://avatars.githubusercontent.com/u/4314092?v=4")
        XCTAssertEqual(repository?.language, "Go")
        XCTAssertEqual(repository?.name, "go")
        XCTAssertEqual(repository?.stars, 119480)
    }
}

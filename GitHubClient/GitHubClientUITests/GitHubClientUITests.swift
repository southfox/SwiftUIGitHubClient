//
//  GitHubClientUITests.swift
//  GitHubClientUITests
//
//  Created by fox on 20/04/2024.
//

import XCTest

final class GitHubClientUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTapOnGoCellInsideCollectionView() throws {
        let app = XCUIApplication()
        app.launch()

        let collectionViewsQuery = XCUIApplication().collectionViews
        let cells = collectionViewsQuery.cells
        XCTAssertEqual(cells.count, 10)
        let goButton = collectionViewsQuery.cells/*@START_MENU_TOKEN@*/.cells.buttons["go, golang/go"]/*[[".cells.buttons[\"go, golang\/go\"]",".buttons[\"go, golang\/go\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        XCTAssertTrue(goButton.waitForExistence(timeout: 5))
        XCTAssertTrue(goButton.exists)
        goButton.tap()

        // Checks if you've have expanded the cell and you can see the brief description = "The Go programming language"
        let appGoCellWithLabelText = app.staticTexts["The Go programming language"]
        XCTAssertTrue(appGoCellWithLabelText.waitForExistence(timeout: 5))
    }
}

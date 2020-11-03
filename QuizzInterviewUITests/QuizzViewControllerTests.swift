//
//  QuizzViewControllerTests.swift
//  QuizzInterviewUITests
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/2/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import XCTest

class QuizzViewControllerTests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

     func testTitleLabel() {
           let titleLabel = app.staticTexts["What are all the java keywords?"]
           XCTAssertTrue(titleLabel.exists)
       }
       
       func testButtonStart() {
           let buttonStart = app.buttons["Start"]
           XCTAssertTrue(buttonStart.exists)
       }
       
       func testTextField() {
           let buttonStart = app.buttons["Start"]
           XCTAssertTrue(buttonStart.exists)
       }
       
       func testCorrectItem() {
           let buttonStart = app.buttons["Start"]
           buttonStart.tap()
           
           let iKey = app.keys["i"]
           iKey.tap()
           
           let fKey = app.keys["f"]
           fKey.tap()
           
           let optionCorrect = app.staticTexts["if"]
           XCTAssertTrue(optionCorrect.exists)
       }
       
       func testWrongOption() {
           let buttonStart = app.buttons["Start"]
           buttonStart.tap()
           
           let iKey = app.keys["a"]
           iKey.tap()
           
           let fKey = app.keys["a"]
           fKey.tap()
           
           let wrongOption = app.staticTexts["aa"]
           XCTAssertFalse(wrongOption.exists)
       }
       
       func testScoreLabel() {
           let buttonStart = app.buttons["Start"]
           buttonStart.tap()
           
           let iKey = app.keys["i"]
           iKey.tap()
           
           let fKey = app.keys["f"]
           fKey.tap()
           
           let eKey = app.keys["e"]
           eKey.tap()
           
           let lKey = app.keys["l"]
           lKey.tap()
           
           let sKey = app.keys["s"]
           sKey.tap()
           
           eKey.tap()
           
           let scoreLabel = app.staticTexts["2/50"]
           XCTAssertTrue(scoreLabel.exists)
       }
       
       func testButtonConstraints() {
           let buttonStart = app.buttons["Start"]
           XCTAssertEqual(buttonStart.frame.height, 44.0)
       }

}

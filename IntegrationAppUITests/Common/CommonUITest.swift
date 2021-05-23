//
//  CommonUITest.swift
//  IntegrationAppUITests
//
//  Created by Dennis Silva on 5/16/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

import XCTest

class CommonUITest: XCTestCase {
  // class default variables
  
  // application variable initialized under the setUp
  var app: XCUIApplication!
  
  // Creates a folder to save screenshots
  var downloadsFolder: URL = {
      let fm = FileManager.default
      let folder = fm.urls(for: .downloadsDirectory, in: .userDomainMask)[0]

      var isDirectory: ObjCBool = false
      if !(fm.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
          try! fm.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
      }
      return folder
  }()

  override func setUp() {
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    // Launch the App
    app = XCUIApplication()
    XCTestObservationCenter.shared.addTestObserver(CustomObserver())
    app.launchEnvironment = ["UI_TEST": "YES"]
    app.launch()
    
    // Disable UI animations to make automation execution faster
    UIView.setAnimationsEnabled(false)
    
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testCheckSimpleNotification() {
    app.buttons["alertsButton"].tap()
    app.buttons["Create App Alert"].tap()
    XCTAssertTrue(app.alerts["Magic"].buttons["Will do"].waitForExistence(timeout: 5), "Simple Alert was not presented")
    app.alerts["Magic"].buttons["Will do"].tap()
    XCTAssertTrue(!app.alerts["Magic"].exists, "Alert was not dismissed")
  }
}

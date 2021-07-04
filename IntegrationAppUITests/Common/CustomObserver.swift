//
//  CustomObserver.swift
//  IntegrationAppUITests
//
//  Created by Dennis Silva on 5/16/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import XCTest

class CustomObserver: NSObject, XCTestObservation {
  // Add Test Observer on init
  override init() {
     super.init()
     XCTestObservationCenter.shared.addTestObserver(self)
  }
  
  // Handle Test Case Failure
  public func testCase(_ testCase: XCTestCase, didRecord issue: XCTIssue) {
    let currentTest = testCase as? CommonUITest
    print("Test Case Failed")
    let file = issue.sourceCodeContext.location?.fileURL.absoluteString ?? "File Path not provided by Xcode"
    let errorLine = issue.sourceCodeContext.location?.lineNumber ?? 0
    let failMessage = "__Error:__ \(issue.description)\nOn File: \(file)\nAt Line:\(errorLine)"
    print("TestCase Failed \(failMessage)")
    //TODO: interact with testing tool and fail the test
  }

  // Handle Test Case Pass
  public func testCaseDidFinish(_ testCase: XCTestCase) {
    let testRun = testCase.testRun!
    let verb = testRun.hasSucceeded
    // Grab information from the Test by Casting into the common Test Case Class (if needed)
    // NOT NEEDED if you don't need any information/variable from the test itself
    let currentTest = testCase as? CommonUITest
    if verb == true {
      print("TestCase Passed")
      //TODO: interact with testing tool and pass the test
    }
  }
  
  // Remove Observer
  func testBundleDidFinish(_ testBundle: Bundle) {
    XCTestObservationCenter.shared.removeTestObserver(self)
  }
}

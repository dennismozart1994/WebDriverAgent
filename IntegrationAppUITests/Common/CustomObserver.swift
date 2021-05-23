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
  // Handle Test Case Failure
  public func testCase(_ testCase: XCTestCase,
                       didFailWithDescription description: String,
                       inFile filePath: String?,
                       atLine lineNumber: Int) {
    // Grab information from the Test by Casting into the common Test Case Class (if needed)
    // NOT NEEDED if you don't need any information/variable from the test itself
    let currentTest = testCase as? CommonUITest
    
    let failMessage = "__Error:__ \(description)\nOn File: \(filePath ?? "File Path not provided by Xcode")\nAt Line: \(lineNumber)"
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
}

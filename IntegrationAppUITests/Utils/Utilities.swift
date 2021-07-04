//
//  Utilities.swift
//  IntegrationAppUITests
//
//  Created by Dennis Silva on 5/22/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import XCTest

class Utilities {
  /**
   Expect until an specific element property check is true
   We can use this to wait until an element complete its loading or until some property is set as we desire
   Such as Hitable, Visible, Value, etc
   - Parameter element: Element to wait loading
   - Parameter timeout: Time to wait until consider that the element expectation failed
   - Parameter condition: Predicate with element property to check
   - Returns: If the expectations were reach or not
   */
  func expect(element: XCUIElement, timeout: TimeInterval, condition: NSPredicate) -> Bool {
    let expectation = XCTNSPredicateExpectation(predicate: condition, object: element)
    let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
    return result == .completed
  }
}

extension XCUIElement {
  static let existPredicate = NSPredicate(format: "exists == TRUE")
  static let notExistPredicate = NSPredicate(format: "exists == FALSE")
  static let hittablePredicate = NSPredicate(format: "hittable == TRUE")
  static let notHittablePredicate = NSPredicate(format: "hittable == FALSE")
  
  /**
   Scroll Down to element position
   - Warning: Quicker scroll, but element found could end up not being interactable due to possibility of element being hiddend during swipe actions
   - Parameter element: Element you attempt to find with scroll
   */
  func scrollDownToElement(element: XCUIElement) {
      var attempts = 0
      while !element.visible() && attempts < 20 {
          swipeUp()
          attempts+=1
      }
      
      // If item wasn't found on the list within 20 swipes fail the test
      if(attempts >= 20) {
          XCTFail("Element \(element.debugDescription) was not found on table after scroll")
      }
  }
  
  /**
   Scroll Down until the element center coordinates position
   - Warning: Slower scroll since it swipes within -50 coordinates at a time until the element center position, but it's more likely that the final element is interactable
   - Parameter element: Element you attempt to find with scroll
   */
  func scrollDownToElementCoordinates(element: XCUIElement) {
      var attempts = 0
      while !element.visible() && attempts < 20 {
          let startCoord = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
          let endCoord = startCoord.withOffset(CGVector(dx: 0.0, dy: -50));
          startCoord.press(forDuration: 0.01, thenDragTo: endCoord)
          attempts+=1
      }
      
      // If item wasn't found on the list within 20 swipes fail the test
      if(attempts >= 20) {
          XCTFail("Element \(element.debugDescription) was not found on table after scroll")
      }
  }
  
  /**
   Check if an element is visible into the UI
   - Warning: Element needs to be on the screen, be hittable and into the UI hierarchy
   - Returns: If element is visible on the screen or not
   */
  func visible() -> Bool {
      guard self.exists && self.isHittable && !self.frame.isEmpty else { return false }
      return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
  }

  /**
   Wait for element to exists on the UI
   - Warning: Be careful while using this, the test is failed if element does not exists on the UI after the timeout
   - Parameter timeout: Limit time in seconds to wait element to appear in the UI before failing the test
   - Parameter failMessage: Fail message to be logged if at the end the element is not present on the UI
   */
  func waitForElement(timeout: TimeInterval, failMessage: String) {
      let utils = Utilities()
      let result = utils.expect(element: self, timeout: timeout, condition: XCUIElement.existPredicate)
      
      if(!result) {
          XCTFail(failMessage)
      }
  }
  
  /**
   Wait for element to disappear from the UI
   - Warning: Be careful while using this, the test is failed if element still exists on the UI after the timeout
   - Parameter timeout: Limit time in seconds to wait element to disapear of the UI before failing the test
   - Parameter failMessage: Fail message to be logged if at the end the element is still present on the UI
   */
  func waitForDisappear(timeout: TimeInterval, failMessage: String) {
      let utils = Utilities()
      let result = utils.expect(element: self, timeout: timeout, condition: XCUIElement.notExistPredicate)
      
      if(!result) {
          XCTFail(failMessage)
      }
  }
  
  /**
   Wait for element to be hittable on the UI
   - Warning: Be careful while using this, the test is failed if element still not hittable on the UI after the timeout
   - Parameter timeout: Limit time in seconds to wait element to be hittable of the UI before failing the test
   - Parameter failMessage: Fail message to be logged if at the end the element is still not hittable on the UI
   */
  func waitToBeHittable(timeout: TimeInterval, failMessage: String){
      let utils = Utilities()
      let result = utils.expect(element: self, timeout: timeout, condition: XCUIElement.hittablePredicate)
      
      if(!result) {
          XCTFail(failMessage)
      }
  }
  
  /**
   Attempts to tap into the element until timeout is reached
   - Warning: Be careful while using this, the test is failed if its not possible to tap into the element after the timeout
   - Parameter timeout: Limit time in seconds to keep trying to tap on element before failing the test
   - Parameter failMessage: Fail message to be logged if at the end it was not possible to tap on the element
   */
  func expectAndTap(timeout: TimeInterval, failMessage: String) {
      let utils = Utilities()
      let result = utils.expect(element: self, timeout: timeout, condition: XCUIElement.existPredicate)
      
      if(result) {
          self.tap()
      } else {
          XCTFail(failMessage)
      }
  }
  
  /**
   Force a tap into the element central coordinates, even for an element is not hittable
   - Warning: It's not guaranteed that something will happen when taping into the coordinates, it also doesn't wait any event loading before tapping into te coordinates
   */
  func forceTap(){
      let centralCoordinate = CGVector(dx: 0.5, dy: 0.5)
      self.coordinate(withNormalizedOffset: centralCoordinate).tap()
  }
  
  /**
   Drag and drop an element into the center of an element or into specified coordinates
   - Warning: If andDropToCoordinate AND andDropToCoordinate are not specified, the test will fail due to invalid arguments
   - Parameter andDropToElement: Element to drop, if not passed andDropToCoordinate will be used
   - Parameter andDropToCoordinate: Coordinates to drop element, if not passed, andDropToElement parameter will be used
   */
  func drag(andDropToElement: XCUIElement? = nil, andDropToCoordinate: XCUICoordinate? = nil) {
      var dropPoint: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
      
      // if an element is specified to drop, use it
      if andDropToElement != nil {
          dropPoint = andDropToElement!.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
      // if an coordinate is specified to drop, use it instead
      } else if andDropToCoordinate != nil {
          dropPoint = andDropToCoordinate!
      // if nothing is specified to drop then why are you try to drag and drop instead of tapping or long pressing?
      } else {
          XCTFail("Invalid Element to Drop")
      }
      
      let dragPoint = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
      dragPoint.press(forDuration: 1, thenDragTo: dropPoint)
      
  }
  
  /**
   Fill a text field and hide the keyboard after doing so
   - Warning: Should only be used into Text Field UI elements
   - Parameter text: input to type into the Text Field
   */
  func fullfillWith(text: String) {
      self.expectAndTap(timeout: 15, failMessage: "Fail to tap on Text Field")
      self.typeText(text + "\n")
  }
  
  /**
   Fill NumPad elements with data with desired input
   - Warning: There's no need to use this as a XCUIElement function other than making NumPad interactions more readable into the test level
   - Parameter testApp: XCUIApplication to use to interact with NumPad element
   - Parameter numberInput: Input data to type into the NumPad element
   */
  func numpadEntry(testApp: XCUIApplication, numberInput: String) {
    for char in numberInput{
        testApp.buttons[String(char)].firstMatch.expectAndTap(timeout: 15, failMessage: "Fail to tap on \(String(char)) button")
    }
    testApp.buttons["done"].firstMatch.expectAndTap(timeout: 15, failMessage: "Fail to tap on Done button")
  }

}

extension CommonUITest {
    /**
     Take a screenshot, add into the test log attachments and saves into the runner app
     This will be useful to store evidences to upload or use as test evidences later
     - Parameter fileName: Screenshot Name
     - Returns: URL to file, useful to upload as an evidence to a Testing Tool later
     */
    func takeScreenshot(fileName: String = "") -> URL? {
        let appshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: appshot)
        attachment.name = fileName.isEmpty ? "Screenshot" : fileName
        attachment.lifetime = .keepAlways
        self.add(attachment)
        
        // Save to container
        let screenshotName = fileName.isEmpty ? "Screenshot" : fileName
        let url = downloadsFolder.appendingPathComponent("\(screenshotName).png")
        try! appshot.pngRepresentation.write(to: url)
        return url
    }
}

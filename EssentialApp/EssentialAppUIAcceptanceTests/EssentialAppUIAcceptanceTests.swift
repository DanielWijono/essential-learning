//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Silverius Daniel Wijono on 29/08/23.
//

import XCTest

class EssentialAppUIAcceptanceTests: XCTestCase {
  
  func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
    let app = XCUIApplication()
    
    app.launch()
    
    XCTAssertEqual(app.cells.count, 22)
    XCTAssertEqual(app.cells.firstMatch.images.count, 1)
  }
}

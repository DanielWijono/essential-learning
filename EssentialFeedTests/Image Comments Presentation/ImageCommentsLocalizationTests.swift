//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Silverius Daniel Wijono on 14/09/23.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {
  
  func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
    let table = "ImageComments"
    let bundle = Bundle(for: ImageCommentsPresenter.self)
    
    assertLocalizedKeyAndValuesExist(in: bundle, table)
  }
  
}

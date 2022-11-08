//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Silverius Daniel Wijono on 08/11/22.
//

import Foundation

func anyNSError() -> NSError {
  return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
  return URL(string: "http://any-url.com")!
}

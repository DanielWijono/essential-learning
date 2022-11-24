//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Silverius Daniel Wijono on 24/11/22.
//

import XCTest
import EssentialFeed
import Foundation

class CodableFeedStore {
  func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
    completion(.empty)
  }

}

class CodableFeedStoreTests: XCTestCase {
  
  func test_retrieve_deliversOnEmptyCache() {
    let sut = CodableFeedStore()
    let exp = expectation(description: "Wait for cache retrieval")
    
    sut.retrieve { result in
      switch result {
      case .empty:
        break
        
      default:
        XCTFail("Expected empty result, got \(result) instead")
      }
      
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
  }
}

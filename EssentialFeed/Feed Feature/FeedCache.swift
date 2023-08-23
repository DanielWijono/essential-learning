//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 23/08/23.
//

import Foundation

public protocol FeedCache {
  typealias Result = Swift.Result<Void, Error>
  
  func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
